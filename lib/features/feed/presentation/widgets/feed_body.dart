import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/feed_provider.dart';
import 'post_card.dart';

class FeedBody extends StatelessWidget {
  const FeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.status == FeedStatus.error) {
      return Center(
        child: Text(
          provider.error ?? 'Error loading feed',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (provider.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 48.w, color: AppColors.imagePlaceholder),
            SizedBox(height: 12.h),
            Text(
              'No posts yet',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            SizedBox(height: 6.h),
            Text(
              'Be the first to share something\nwith your campus.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemCount: provider.posts.length,
      itemBuilder: (ctx, i) => PostCard(post: provider.posts[i]),
    );
  }
}
