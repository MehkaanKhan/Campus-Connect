import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class NotificationTileShimmer extends StatelessWidget {
  const NotificationTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Box(width: 40.w, height: 40.w, radius: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Box(width: double.infinity, height: 13.h),
                SizedBox(height: 5.h),
                _Box(width: 200.w, height: 13.h),
                SizedBox(height: 6.h),
                _Box(width: 70.w, height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsShimmerList extends StatelessWidget {
  const NotificationsShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, _) =>
            Divider(height: 1, color: AppColors.border),
        itemBuilder: (_, _) => const NotificationTileShimmer(),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const _Box({required this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
