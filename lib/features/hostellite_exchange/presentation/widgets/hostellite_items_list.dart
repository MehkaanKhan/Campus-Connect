import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../provider/hostellite_provider.dart';
import 'hostellite_item_card.dart';
import 'hostellite_item_shimmer.dart';

class HostelliteItemsList extends StatelessWidget {
  const HostelliteItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HostelliteProvider>();
    if (provider.isLoading) return const HostelliteShimmerList();
    if (provider.status == HostelliteStatus.error) {
      return ErrorState(
        message: provider.error,
        onRetry: () => context.read<HostelliteProvider>().load(),
      );
    }
    if (provider.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 48.w, color: AppColors.imagePlaceholder),
            SizedBox(height: 12.h),
            Text(
              'No items listed yet',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Be the first to list something!',
              style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
      itemCount: provider.items.length,
      itemBuilder: (ctx, i) => HostelliteItemCard(item: provider.items[i]),
    );
  }
}
