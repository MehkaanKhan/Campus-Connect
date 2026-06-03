import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/feed_provider.dart';
import 'post_card.dart';
import 'post_card_shimmer.dart';

class FeedBody extends StatelessWidget {
  const FeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    if (provider.isLoading) return const FeedShimmerList();
    if (provider.status == FeedStatus.error) {
      final isNoUniversity = provider.error?.contains('university') ?? false;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isNoUniversity
                  ? Icon(Icons.school_outlined, size: 52.w, color: AppColors.imagePlaceholder)
                  : SvgPicture.asset(AppAssets.iconWifiOff, width: 52.w, height: 52.w, colorFilter: ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
              SizedBox(height: 16.h),
              Text(
                isNoUniversity ? 'Set up your university' : 'Could not load feed',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                provider.error ?? 'Something went wrong. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textMuted, height: 1.55),
              ),
              if (isNoUniversity) ...[
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => context.push('/profile-setup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Text('Complete Profile Setup', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ),
              ] else ...[
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () => context.read<FeedProvider>().loadFeed(),
                  child: Text(
                    'Try Again',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    if (provider.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.iconArticle, width: 48.w, height: 48.w, colorFilter: ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
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
