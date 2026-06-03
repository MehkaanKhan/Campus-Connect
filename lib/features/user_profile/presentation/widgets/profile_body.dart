import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/user_profile_provider.dart';
import 'profile_shimmer.dart';
import 'profile_card.dart';
import 'profile_posts_list.dart';
import 'profile_carpools_list.dart';

class ProfileBody extends StatelessWidget {
  final TabController tabController;
  const ProfileBody({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();

    if (provider.isLoading) return const ProfileShimmer();

    if (provider.profile == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.iconProfile, width: 48.w, height: 48.w, colorFilter: ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
            SizedBox(height: 12.h),
            Text(
              provider.error != null ? 'Failed to load profile' : 'Profile not found',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            if (provider.error != null) ...[
              SizedBox(height: 6.h),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      );
    }

    final p = provider.profile!;

    final tabBar = TabBar(
      controller: tabController,
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      labelColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textMuted,
      indicatorColor: AppColors.sage,
      indicatorWeight: 2.5,
      dividerColor: AppColors.border,
      tabs: const [
        Tab(text: 'Posts'),
        Tab(text: 'Reactions'),
        Tab(text: 'Carpools'),
      ],
    );

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(child: ProfileCard(profile: p)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(tabBar),
        ),
      ],
      body: TabBarView(
        controller: tabController,
        children: [
          ProfilePostsList(posts: p.posts),
          ProfilePostsList(posts: p.reactedPosts, emptyLabel: 'No reacted posts yet'),
          ProfileCarpoolsList(carpools: p.joinedCarpools),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.cardBg,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
