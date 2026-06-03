import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/post_image_container.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/thread?id=${post.id}'),
      child: Container(
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
                  _FlairChip(
                    label: post.flair,
                    color: AppColors.flairColor(post.flair),
                  ),
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
              PostImageContainer(imageUrl: post.imageUrl!),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
              child: _PostActions(post: post),
            ),
          ],
        ),
      ),
    );
  }
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
        GestureDetector(
          onTap: () => _showPostMenu(context, post),
          child: SvgPicture.asset(AppAssets.iconMoreHorizontal, width: 20.w, height: 20.w, colorFilter: ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
        ),
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
      case 'events':
        return Icons.event_outlined;
      case 'academic':
        return Icons.school_outlined;
      case 'hostel':
        return Icons.home_outlined;
      case 'carpool':
        return Icons.directions_car_outlined;
      case 'marketplace':
        return Icons.storefront_outlined;
      default:
        return Icons.label_outline;
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
          child: SvgPicture.asset(AppAssets.iconVoteUp, width: 16.w, height: 16.w, colorFilter: ColorFilter.mode(upColor, BlendMode.srcIn)),
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
          child: SvgPicture.asset(AppAssets.iconVoteDown, width: 16.w, height: 16.w, colorFilter: ColorFilter.mode(downColor, BlendMode.srcIn)),
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: () => context.push('/thread?id=${post.id}'),
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.iconReply, width: 15.w, height: 15.w, colorFilter: ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
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
        GestureDetector(
          onTap: () => _sharePost(context, post),
          child: SvgPicture.asset(AppAssets.iconShare, width: 17.w, height: 17.w, colorFilter: ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
        ),
      ],
    );
  }
}

Future<void> _sharePost(BuildContext context, PostEntity post) async {
  final text = '${post.title}\n\n${post.excerpt}\n\nShared from Campus Connect';
  final messenger = ScaffoldMessenger.of(context);
  try {
    final result = await SharePlus.instance.share(ShareParams(text: text));
    if (result.status == ShareResultStatus.unavailable) {
      await Clipboard.setData(ClipboardData(text: text));
      messenger.showSnackBar(
        const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2)),
      );
    }
  } catch (_) {
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(
      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2)),
    );
  }
}

void _showPostMenu(BuildContext context, PostEntity post) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.cardBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Icon(Icons.link, color: AppColors.textPrimary),
            title: Text(
              'Copy link',
              style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Inter'),
            ),
            onTap: () {
              Clipboard.setData(ClipboardData(text: 'campusconnect://thread/${post.id}'));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.flag_outlined, color: AppColors.error),
            title: Text(
              'Report post',
              style: TextStyle(color: AppColors.error, fontFamily: 'Inter'),
            ),
            onTap: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post reported. Thank you.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
