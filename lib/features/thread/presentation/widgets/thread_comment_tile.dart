import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/thread_entity.dart';

class ThreadCommentTile extends StatelessWidget {
  final CommentEntity comment;
  final bool isNested;
  final void Function(String commentId, String authorName)? onReply;

  const ThreadCommentTile({
    super.key,
    required this.comment,
    required this.isNested,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final upvoteColor = comment.upvotes < 0 ? AppColors.negativeVote : AppColors.textCaption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
            isNested ? 32.w : 16.w,
            8.h,
            16.w,
            8.h,
          ),
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
          decoration: BoxDecoration(
            color: isNested ? AppColors.altPageBg : AppColors.cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: isNested
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 15.w,
                    backgroundColor: isNested
                        ? AppColors.commentNestedAvatarBg
                        : AppColors.commentAvatarBg,
                    backgroundImage: comment.authorAvatarUrl != null
                        ? NetworkImage(comment.authorAvatarUrl!)
                        : null,
                    child: comment.authorAvatarUrl == null
                        ? SvgPicture.asset(AppAssets.iconProfile, width: 16, height: 16, colorFilter: const ColorFilter.mode(Colors.white60, BlendMode.srcIn))
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    comment.authorName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (comment.isOp) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'OP',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(width: 6.w),
                  Text(
                    comment.timeAgo,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.navInactive),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SvgPicture.asset(AppAssets.iconVoteUp, width: 16.w, height: 16.w, colorFilter: ColorFilter.mode(upvoteColor, BlendMode.srcIn)),
                      Text(
                        '${comment.upvotes}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: upvoteColor,
                        ),
                      ),
                      SvgPicture.asset(AppAssets.iconVoteDown, width: 14.w, height: 14.w, colorFilter: ColorFilter.mode(AppColors.textHint, BlendMode.srcIn)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                comment.content,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.5,
                  color: AppColors.textCaption,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => onReply?.call(comment.id, comment.authorName),
                child: Row(
                  children: [
                    SvgPicture.asset(AppAssets.iconCornerRight, width: 13.w, height: 13.w, colorFilter: ColorFilter.mode(AppColors.navInactive, BlendMode.srcIn)),
                    SizedBox(width: 3.w),
                    Text(
                      'REPLY',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textLabel,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (comment.replies.isNotEmpty)
          ...comment.replies.map(
            (r) => ThreadCommentTile(comment: r, isNested: true, onReply: onReply),
          ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
