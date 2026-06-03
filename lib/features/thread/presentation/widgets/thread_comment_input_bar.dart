import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/thread_provider.dart';
import '../../../feed/presentation/provider/feed_provider.dart';

class ThreadCommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const ThreadCommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThreadProvider>();

    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.replyToName != null)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  SvgPicture.asset(AppAssets.iconReply, width: 13.w, height: 13.w, colorFilter: ColorFilter.mode(AppColors.sage, BlendMode.srcIn)),
                  SizedBox(width: 4.w),
                  Text(
                    'Replying to ${provider.replyToName}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sage,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: provider.clearReplyTarget,
                    child: SvgPicture.asset(AppAssets.iconClose, width: 15.w, height: 15.w, colorFilter: ColorFilter.mode(AppColors.textHint, BlendMode.srcIn)),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
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
                  if (controller.text.trim().isNotEmpty) {
                    final postId = provider.activePostId;
                    if (postId != null) {
                      context.read<FeedProvider>().incrementCommentCount(postId);
                    }
                    await provider.submitComment();
                    controller.clear();
                  }
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
                            SvgPicture.asset(AppAssets.iconPlay, width: 16.w, height: 16.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
