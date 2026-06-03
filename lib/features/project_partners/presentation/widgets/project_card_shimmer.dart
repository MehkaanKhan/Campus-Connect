import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ProjectCardShimmer extends StatelessWidget {
  const ProjectCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Box(width: 80.w, height: 22.h, radius: 4.r),
              const Spacer(),
              _Box(width: 20.w, height: 20.w, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),
          _Box(width: 200.w, height: 18.h),
          SizedBox(height: 6.h),
          _Box(width: 140.w, height: 18.h),
          SizedBox(height: 10.h),
          _Box(width: double.infinity, height: 12.h),
          SizedBox(height: 5.h),
          _Box(width: double.infinity, height: 12.h),
          SizedBox(height: 5.h),
          _Box(width: 160.w, height: 12.h),
          SizedBox(height: 16.h),
          _Box(width: 90.w, height: 10.h),
          SizedBox(height: 8.h),
          Row(
            children: [
              _Box(width: 70.w, height: 26.h, radius: 100.r),
              SizedBox(width: 7.w),
              _Box(width: 60.w, height: 26.h, radius: 100.r),
              SizedBox(width: 7.w),
              _Box(width: 80.w, height: 26.h, radius: 100.r),
            ],
          ),
          SizedBox(height: 20.h),
          _Box(width: double.infinity, height: 44.h, radius: 10.r),
        ],
      ),
    );
  }
}

class ProjectShimmerList extends StatelessWidget {
  const ProjectShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: Column(
        children: List.generate(
          3,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: const ProjectCardShimmer(),
          ),
        ),
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
