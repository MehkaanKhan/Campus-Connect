import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PostHeader(post: post),
                SizedBox(height: 10.h),
                _FlairChip(label: post.flair, color: post.flairColor),
                SizedBox(height: 8.h),
                Text(
                  post.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (post.imageUrl != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
              child: post.imageUrl!.startsWith('http')
                  ? Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 180.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    )
                  : Image.asset(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 180.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    ),
            ),
          ],
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
            child: _PostActions(post: post),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        width: double.infinity,
        height: 180.h,
        color: AppColors.borderLight,
        child: Icon(Icons.image_outlined, size: 36.w, color: AppColors.imagePlaceholder),
      );
}

class _PostHeader extends StatelessWidget {
  final PostEntity post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 17.r,
          backgroundColor: AppColors.primary,
          backgroundImage: post.authorAvatarUrl != null
              ? NetworkImage(post.authorAvatarUrl!)
              : null,
          child: post.authorAvatarUrl == null
              ? Text(
                  post.authorName[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                post.timeAgo,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.more_horiz, color: AppColors.textMuted, size: 20.w),
      ],
    );
  }
}

class _FlairChip extends StatelessWidget {
  final String label;
  final Color color;
  const _FlairChip({required this.label, required this.color});

  IconData get _icon {
    switch (label.toLowerCase()) {
      case 'events':      return Icons.event_outlined;
      case 'academic':    return Icons.school_outlined;
      case 'hostel':      return Icons.home_outlined;
      case 'carpool':     return Icons.directions_car_outlined;
      case 'marketplace': return Icons.storefront_outlined;
      default:            return Icons.label_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 11.w, color: AppColors.filterInactiveText),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: AppColors.filterInactiveText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  final PostEntity post;
  const _PostActions({required this.post});

  @override
  Widget build(BuildContext context) {
    final feed = context.read<FeedProvider>();
    final upColor = post.isUpvoted ? AppColors.sage : AppColors.textMuted;
    final downColor = post.isDownvoted ? AppColors.error : AppColors.textMuted;

    return Row(
      children: [
        GestureDetector(
          onTap: () => feed.toggleUpvote(post.id),
          child: Icon(Icons.arrow_upward_rounded, size: 16.w, color: upColor),
        ),
        SizedBox(width: 4.w),
        Text(
          '${post.upvotes}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: upColor,
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          onTap: () => feed.toggleDownvote(post.id),
          child: Icon(Icons.arrow_downward_rounded, size: 16.w, color: downColor),
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: () => context.push('/thread'),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 15.w, color: AppColors.textMuted),
              SizedBox(width: 5.w),
              Text(
                '${post.commentCount}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Icon(Icons.share_outlined, size: 17.w, color: AppColors.textMuted),
      ],
    );
  }
}
