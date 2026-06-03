import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class CarpoolRideShimmer extends StatelessWidget {
  const CarpoolRideShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Box(width: 180.w, height: 16.h),
                      SizedBox(height: 8.h),
                      _Box(width: 120.w, height: 12.h),
                    ],
                  ),
                ),
                _Box(width: 44.w, height: 44.w, radius: 22.r),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _Box(width: double.infinity, height: 70.h, radius: 10.r),
                SizedBox(height: 12.h),
                _Box(width: double.infinity, height: 18.h, radius: 8.r),
                SizedBox(height: 14.h),
                _Box(width: double.infinity, height: 42.h, radius: 10.r),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarpoolShimmerList extends StatelessWidget {
  const CarpoolShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => SizedBox(height: 14.h),
        itemBuilder: (_, _) => const CarpoolRideShimmer(),
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
