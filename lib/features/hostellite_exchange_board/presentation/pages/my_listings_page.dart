import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../provider/exchange_board_provider.dart';
import '../widgets/create_item_bottom_sheet.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExchangeBoardProvider>().loadMyItems();
    });
  }

  void _showDeleteDialog(BuildContext context, ExchangeItemEntity item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('Delete Listing', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${item.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await context.read<ExchangeBoardProvider>().deleteExchangeItem(item.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listing deleted successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExchangeBoardProvider>();

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
            trailing: IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CreateItemBottomSheet(),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Listings',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Manage, activate/deactivate, or remove items you have posted on the hostel exchange board.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (provider.isLoading) return const AppLoader();

                      if (provider.error != null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
                                SizedBox(height: 12.h),
                                Text(
                                  provider.error!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.redAccent),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () => provider.loadMyItems(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (provider.myItems.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 50.w, color: AppColors.textMuted),
                              SizedBox(height: 16.h),
                              Text(
                                "You haven't listed any items yet.",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => const CreateItemBottomSheet(),
                                  );
                                },
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text('Add Listing'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemCount: provider.myItems.length,
                        itemBuilder: (ctx, i) {
                          final item = provider.myItems[i];
                          return Card(
                            color: AppColors.cardBg,
                            margin: EdgeInsets.only(bottom: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            elevation: 0,
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () => context.push('/hostellite-exchange/detail', extra: item),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        width: 80.w,
                                        height: 80.h,
                                        color: AppColors.pageBg,
                                        child: item.imageUrl != null
                                            ? (item.imageUrl!.startsWith('http')
                                                ? Image.network(item.imageUrl!, fit: BoxFit.cover, errorBuilder: (ctx, err, stackTrace) => _placeholder())
                                                : Image.asset(item.imageUrl!, fit: BoxFit.cover, errorBuilder: (ctx, err, stackTrace) => _placeholder()))
                                            : _placeholder(),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                                decoration: BoxDecoration(
                                                  color: item.type == ItemType.free
                                                      ? AppColors.freeBadgeBg
                                                      : item.type == ItemType.rent
                                                          ? AppColors.rentBadgeBg
                                                          : AppColors.borrowBadgeBg,
                                                  borderRadius: BorderRadius.circular(4.r),
                                                ),
                                                child: Text(
                                                  item.typeLabel.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: item.type == ItemType.free
                                                        ? AppColors.freeBadgeText
                                                        : item.type == ItemType.rent
                                                            ? AppColors.rentBadgeText
                                                            : AppColors.borrowBadgeText,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                item.conditionLabel,
                                                style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            item.priceLabel,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              Text(
                                                item.isAvailable ? 'Available' : 'Unavailable/Sold',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: item.isAvailable ? Colors.green : Colors.red,
                                                ),
                                              ),
                                              const Spacer(),
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Switch(
                                                  value: item.isAvailable,
                                                  activeThumbColor: Colors.green,
                                                  activeTrackColor: Colors.green.withValues(alpha: 0.3),
                                                  onChanged: (val) {
                                                    provider.updateItemAvailability(item.id, val);
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                                onPressed: () => _showDeleteDialog(context, item),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }

  Widget _placeholder() => const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textMuted),
      );
}
