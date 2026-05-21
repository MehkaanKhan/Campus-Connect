import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../../../hostellite_exchange/presentation/provider/hostellite_provider.dart';
import '../provider/exchange_board_provider.dart';

class ItemDetailPage extends StatelessWidget {
  final ExchangeItemEntity item;

  const ItemDetailPage({super.key, required this.item});

  Future<void> _toggleAvailability(BuildContext context, ExchangeItemEntity currentItem) async {
    final success = await context.read<ExchangeBoardProvider>().updateItemAvailability(currentItem.id, !currentItem.isAvailable);
    if (success && context.mounted) {
      context.read<HostelliteProvider>().load();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentItem.isAvailable ? 'Item marked as sold/unavailable' : 'Item marked as available',
          ),
        ),
      );
      context.pop();
    }
  }

  Future<void> _confirmDelete(BuildContext context, ExchangeItemEntity currentItem) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: const Text('Delete Listing', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this listing? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await context.read<ExchangeBoardProvider>().deleteExchangeItem(currentItem.id);
      if (success && context.mounted) {
        context.read<HostelliteProvider>().load();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing deleted successfully')),
        );
        context.pop();
      }
    }
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            const Icon(Icons.contact_mail_outlined, color: AppColors.primary),
            SizedBox(width: 10.w),
            const Text('Contact Seller', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seller Name:',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
            ),
            Text(
              item.sellerName,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 12.h),
            Text(
              'Email Address:',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
            ),
            Text(
              item.sellerEmail ?? 'No email provided',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
          if (item.sellerEmail != null)
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item.sellerEmail!));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email copied to clipboard')),
                );
              },
              icon: const Icon(Icons.copy, size: 16, color: Colors.white),
              label: const Text('Copy Email', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? currentUid;
    try {
      currentUid = SupabaseService.currentUser?.id;
    } catch (_) {}

    final isOwner = item.sellerId != null && item.sellerId == currentUid;

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () => _confirmDelete(context, item),
                )
              else
                IconButton(
                  icon: const Icon(Icons.report_problem_outlined, color: Colors.white),
                  onPressed: () => context.push('/hostellite-exchange/complaint', extra: item),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: item.imageUrl != null
                  ? (item.imageUrl!.startsWith('http')
                      ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                      : Image.asset(item.imageUrl!, fit: BoxFit.cover))
                  : Container(
                      color: AppColors.borderSlate,
                      child: const Icon(Icons.image, size: 80, color: AppColors.textMuted),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.typeLabel,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.priceLabel,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.isAvailable ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: item.isAvailable ? Colors.green : Colors.red),
                        ),
                        child: Text(
                          item.isAvailable ? 'Available' : 'Sold/Unavailable',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: item.isAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Condition',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.conditionLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          item.sellerName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Posted by',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Text(
                              item.sellerName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isOwner) ...[
                        OutlinedButton.icon(
                          onPressed: () => _toggleAvailability(context, item),
                          icon: Icon(item.isAvailable ? Icons.check_circle_outline : Icons.replay_outlined, size: 16),
                          label: Text(item.isAvailable ? 'Mark Sold' : 'Reactivate'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: item.isAvailable ? Colors.amber : Colors.green,
                            side: BorderSide(color: item.isAvailable ? Colors.amber : Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(120, 42),
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: () => _showContactDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Text('Contact'),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
