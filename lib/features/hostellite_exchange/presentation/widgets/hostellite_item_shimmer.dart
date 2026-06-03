import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class HostelliteItemShimmer extends StatelessWidget {
  const HostelliteItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Box(width: double.infinity, height: 170.h, radius: 0),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Box(width: 180.w, height: 15.h),
                SizedBox(height: 8.h),
                _Box(width: double.infinity, height: 12.h),
                SizedBox(height: 5.h),
                _Box(width: 140.w, height: 12.h),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    _Box(width: 22.w, height: 22.w, radius: 11.r),
                    SizedBox(width: 7.w),
                    _Box(width: 90.w, height: 12.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HostelliteShimmerList extends StatelessWidget {
  const HostelliteShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.h, bottom: 16.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, _) => const HostelliteItemShimmer(),
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
