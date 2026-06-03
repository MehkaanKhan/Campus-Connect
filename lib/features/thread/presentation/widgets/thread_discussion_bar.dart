import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ThreadDiscussionBar extends StatelessWidget {
  final int commentCount;
  final bool allowReplies;
  final ValueChanged<bool> onToggle;

  const ThreadDiscussionBar({
    super.key,
    required this.commentCount,
    required this.allowReplies,
    required this.onToggle,
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
                  text: '($commentCount\nComments)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'MOD: ALLOW\nREPLIES',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.navInactive,
                ),
              ),
              SizedBox(height: 4.h),
              Transform.scale(
                scale: 0.82,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: allowReplies,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.white,
                  activeTrackColor: AppColors.sage,
                  inactiveThumbColor: AppColors.white,
                  inactiveTrackColor: AppColors.imagePlaceholder,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
