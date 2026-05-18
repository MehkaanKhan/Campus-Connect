import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/user_profile_provider.dart';
import 'profile_card.dart';
import 'profile_tab_bar_delegate.dart';
import 'profile_posts_list.dart';
import 'profile_carpools_list.dart';

class ProfileBody extends StatelessWidget {
  final TabController tabController;
  const ProfileBody({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.profile == null) {
      return Center(
        child: Text('Profile not found', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
      );
    }
    final p = provider.profile!;
    return NestedScrollView(
      headerSliverBuilder: (ctx, _) => [
        SliverToBoxAdapter(child: ProfileCard(profile: p)),
        SliverPersistentHeader(
          pinned: true,
          delegate: ProfileTabBarDelegate(tabController),
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
