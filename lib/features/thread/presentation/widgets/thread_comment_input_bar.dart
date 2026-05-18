import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/thread_provider.dart';

class ThreadCommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  const ThreadCommentInputBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThreadProvider>();

    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: provider.setCommentDraft,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.altPageBg,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: BorderSide(color: AppColors.sage, width: 1.2),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () async {
              await provider.submitComment();
              controller.clear();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
              decoration: BoxDecoration(
                color: AppColors.sage,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: provider.status == ThreadStatus.loading
                  ? SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'POST',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.play_arrow_rounded, size: 16.w, color: Colors.white),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
