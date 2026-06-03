import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class LeaderboardShimmer extends StatelessWidget {
  const LeaderboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Box(width: 220.w, height: 28.h),
            SizedBox(height: 8.h),
            _Box(width: 160.w, height: 13.h),
            SizedBox(height: 20.h),
            ...List.generate(3, (_) => _TopCardShimmer()),
            SizedBox(height: 16.h),
            _Box(width: double.infinity, height: 1.h),
            SizedBox(height: 16.h),
            ...List.generate(5, (_) => _RowShimmer()),
          ],
        ),
      ),
    );
  }
}

class _TopCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _Box(width: 44.w, height: 44.w, radius: 22.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Box(width: 120.w, height: 14.h),
                SizedBox(height: 6.h),
                _Box(width: 80.w, height: 12.h),
              ],
            ),
          ),
          _Box(width: 50.w, height: 20.h, radius: 10.r),
        ],
      ),
    );
  }
}

class _RowShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          _Box(width: 28.w, height: 14.h),
          SizedBox(width: 12.w),
          _Box(width: 36.w, height: 36.w, radius: 18.r),
          SizedBox(width: 12.w),
          Expanded(child: _Box(width: 120.w, height: 14.h)),
          _Box(width: 50.w, height: 14.h),
        ],
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
