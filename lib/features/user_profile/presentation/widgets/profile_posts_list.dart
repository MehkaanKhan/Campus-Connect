import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfilePostsList extends StatelessWidget {
  final List<ProfilePostEntity> posts;
  final String emptyLabel;
  const ProfilePostsList({super.key, required this.posts, this.emptyLabel = 'No posts yet'});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Text(emptyLabel, style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      itemCount: posts.length,
      itemBuilder: (ctx, i) => Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: ProfilePostCard(post: posts[i]),
      ),
    );
  }
}

class ProfilePostCard extends StatelessWidget {
  final ProfilePostEntity post;
  const ProfilePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/thread?id=${post.id}'),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    post.flair,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textLabel,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  post.timeAgo,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              post.title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              post.excerpt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                color: AppColors.textFaint,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset('assets/icons/icons/vote_up.svg', width: 15.w, height: 15.w, colorFilter: ColorFilter.mode(AppColors.textLabel, BlendMode.srcIn)),
                SizedBox(width: 4.w),
                Text(
                  '${post.upvotes}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: AppColors.textLabel,
                  ),
                ),
                SizedBox(width: 14.w),
                SvgPicture.asset('assets/icons/icons/reply.svg', width: 14.w, height: 14.w, colorFilter: ColorFilter.mode(AppColors.textLabel, BlendMode.srcIn)),
                SizedBox(width: 4.w),
                Text(
                  '${post.commentCount}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: AppColors.textLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
