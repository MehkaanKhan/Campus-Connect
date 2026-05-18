import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  const ProfileTabBarDelegate(this.controller);

  @override
  double get minExtent => SizeConfig.h(48);
  @override
  double get maxExtent => SizeConfig.h(48);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.cardBg,
      child: TabBar(
        controller: controller,
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
        indicatorWeight: 2.5.h,
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Reactions'),
          Tab(text: 'Joined Carpools'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(ProfileTabBarDelegate old) => false;
}
