import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ExploreCard extends StatelessWidget {
  final String svgAsset;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final VoidCallback? onTap;

  const ExploreCard({
    super.key,
    required this.svgAsset,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? onTap
          : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coming soon!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isEnabled ? AppColors.border : AppColors.borderLight,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: isEnabled ? iconBg : AppColors.borderLight,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgAsset,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(
                    isEnabled ? iconColor : AppColors.disabled,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isEnabled ? AppColors.textPrimary : AppColors.disabled,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: isEnabled ? AppColors.textMuted : AppColors.imagePlaceholder,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            if (isEnabled)
              SvgPicture.asset(
                'assets/icons/icons/arrow_right.svg',
                width: 22.w,
                height: 22.w,
                colorFilter: ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.filterInactiveBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Soon',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
