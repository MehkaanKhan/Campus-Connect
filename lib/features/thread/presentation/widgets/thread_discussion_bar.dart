import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ThreadDiscussionBar extends StatelessWidget {
  final int commentCount;

  const ThreadDiscussionBar({
    super.key,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.altPageBg,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
              children: [
                const TextSpan(
                  text: 'Discussion ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '($commentCount Comments)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
