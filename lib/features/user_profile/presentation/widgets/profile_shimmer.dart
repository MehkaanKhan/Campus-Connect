import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _ProfileCardShimmer()),
          SliverToBoxAdapter(child: _TabBarShimmer()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, _) => const _PostRowShimmer(),
              childCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar circle
          _Box(width: 88.r, height: 88.r, radius: 44.r),
          SizedBox(height: 10.h),
          // Name
          _Box(width: 180.w, height: 22.h, radius: 6.r),
          SizedBox(height: 8.h),
          // Department / year
          _Box(width: 120.w, height: 13.h, radius: 5.r),
          SizedBox(height: 14.h),
          // Bio lines
          _Box(width: double.infinity, height: 12.h, radius: 5.r),
          SizedBox(height: 6.h),
          _Box(width: 200.w, height: 12.h, radius: 5.r),
          SizedBox(height: 18.h),
          // Stats row
          Row(
            children: [
              Expanded(child: _StatShimmer()),
              Container(width: 1, height: 34.h, color: AppColors.border),
              Expanded(child: _StatShimmer()),
              Container(width: 1, height: 34.h, color: AppColors.border),
              Expanded(child: _StatShimmer()),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Box(width: 36.w, height: 18.h, radius: 5.r),
        SizedBox(height: 4.h),
        _Box(width: 44.w, height: 10.h, radius: 4.r),
      ],
    );
  }
}

class _TabBarShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(child: Center(child: _Box(width: 50.w, height: 12.h, radius: 5.r))),
          Expanded(child: Center(child: _Box(width: 70.w, height: 12.h, radius: 5.r))),
          Expanded(child: Center(child: _Box(width: 60.w, height: 12.h, radius: 5.r))),
        ],
      ),
    );
  }
}

class _PostRowShimmer extends StatelessWidget {
  const _PostRowShimmer();

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
          _Box(width: double.infinity, height: 13.h),
          SizedBox(height: 6.h),
          _Box(width: 200.w, height: 13.h),
          SizedBox(height: 14.h),
          Row(
            children: [
              _Box(width: 50.w, height: 12.h),
              SizedBox(width: 20.w),
              _Box(width: 40.w, height: 12.h),
            ],
          ),
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
