import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class OnboardingTermsText extends StatelessWidget {
  const OnboardingTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textLabel,
          height: 1.6,
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms',
            style: TextStyle(
              color: AppColors.textCaption,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textCaption,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy\nPolicy',
            style: TextStyle(
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textPrimary,
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
