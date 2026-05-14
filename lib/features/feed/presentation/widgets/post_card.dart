import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/post_entity.dart';
import '../provider/feed_provider.dart';
import '../../../../core/constants/app_theme.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PostHeader(post: post),
                const SizedBox(height: 10),
                _FlairChip(label: post.flair, color: post.flairColor),
                const SizedBox(height: 8),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (post.imageUrl != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
              child: post.imageUrl!.startsWith('http')
                  ? Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    )
                  : Image.asset(
                      post.imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(),
                    ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: _PostActions(post: post),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        width: double.infinity,
        height: 180,
        color: AppColors.borderLight,
        child: const Icon(Icons.image_outlined, size: 36, color: Color(0xFFCCCCC8)),
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
          radius: 17,
          backgroundColor: AppColors.primary,
          backgroundImage: post.authorAvatarUrl != null
              ? NetworkImage(post.authorAvatarUrl!)
              : null,
          child: post.authorAvatarUrl == null
              ? Text(
                  post.authorName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                post.timeAgo,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: AppColors.textMuted, size: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 11, color: AppColors.filterInactiveText),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
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
          child: Icon(Icons.arrow_upward_rounded, size: 16, color: upColor),
        ),
        const SizedBox(width: 4),
        Text(
          '${post.upvotes}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: upColor,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => feed.toggleDownvote(post.id),
          child: Icon(Icons.arrow_downward_rounded, size: 16, color: downColor),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => context.push('/thread'),
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 15, color: AppColors.textMuted),
              const SizedBox(width: 5),
              Text(
                '${post.commentCount}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Icon(Icons.share_outlined, size: 17, color: AppColors.textMuted),
      ],
    );
  }
}
