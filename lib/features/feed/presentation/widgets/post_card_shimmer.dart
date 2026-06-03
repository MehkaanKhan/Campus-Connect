import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Box(width: 34.w, height: 34.w, radius: 17.r),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Box(width: 110.w, height: 12.h),
                  SizedBox(height: 5.h),
                  _Box(width: 60.w, height: 9.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _Box(width: 60.w, height: 18.h, radius: 5.r),
          SizedBox(height: 10.h),
          _Box(width: double.infinity, height: 14.h),
          SizedBox(height: 6.h),
          _Box(width: 200.w, height: 14.h),
          SizedBox(height: 6.h),
          _Box(width: double.infinity, height: 12.h),
          SizedBox(height: 14.h),
          Row(
            children: [
              _Box(width: 50.w, height: 14.h),
              SizedBox(width: 20.w),
              _Box(width: 40.w, height: 14.h),
              const Spacer(),
              _Box(width: 20.w, height: 14.h),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedShimmerList extends StatelessWidget {
  const FeedShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, _) => const PostCardShimmer(),
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
