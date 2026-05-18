import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12.h),
          Expanded(
            flex: 6,
            child: _HeroImageCard(imagePath: imagePath),
          ),
          SizedBox(height: 28.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              height: 1.55,
              color: AppColors.textCaption,
            ),
          ),
          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}

class _HeroImageCard extends StatelessWidget {
  final String imagePath;
  const _HeroImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        );
      },
    );
  }
}
