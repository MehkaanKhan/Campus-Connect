import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class OtherUnisShimmer extends StatelessWidget {
  const OtherUnisShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => const _UniCardShimmer(),
      ),
    );
  }
}

class _UniCardShimmer extends StatelessWidget {
  const _UniCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circle avatar
          Container(
            width: 70.r,
            height: 70.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
          ),
          SizedBox(height: 12.h),
          // Name line 1
          _Box(width: 80.w, height: 11.h),
          SizedBox(height: 5.h),
          // Name line 2
          _Box(width: 56.w, height: 11.h),
          SizedBox(height: 6.h),
          // Region
          _Box(width: 48.w, height: 10.h),
          SizedBox(height: 12.h),
          // Member count pill
          Container(
            width: 72.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width;
  final double height;
  const _Box({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
