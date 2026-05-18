import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../widgets/explore_card.dart';

class ExploreHubPage extends StatelessWidget {
  const ExploreHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          const CampusTopNavBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Discover what\'s happening around campus.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  ExploreCard(
                    icon: Icons.group_outlined,
                    iconColor: AppColors.primary,
                    iconBg: const Color(0xFFE8EDF8),
                    title: 'Find Project Partners',
                    subtitle: 'Collaborate on projects, startups & research',
                    isEnabled: true,
                    onTap: () => context.push('/project-partners'),
                  ),
                  SizedBox(height: 12.h),
                  ExploreCard(
                    icon: Icons.swap_horiz_rounded,
                    iconColor: AppColors.sage,
                    iconBg: AppColors.sageLight,
                    title: 'Hostellite Exchange',
                    subtitle: 'Borrow, rent or find free items on campus',
                    isEnabled: true,
                    onTap: () => context.push('/hostellite-exchange'),
                  ),
                  SizedBox(height: 12.h),
                  ExploreCard(
                    icon: Icons.directions_car_outlined,
                    iconColor: AppColors.sage,
                    iconBg: AppColors.sageLight,
                    title: 'Carpool & Rides',
                    subtitle: 'Share rides with fellow students',
                    isEnabled: true,
                    onTap: () => context.push('/carpool'),
                  ),
                  SizedBox(height: 12.h),
                  ExploreCard(
                    icon: Icons.leaderboard_outlined,
                    iconColor: const Color(0xFFB0A890),
                    iconBg: AppColors.disabledBg,
                    title: 'Weekly Leaderboard',
                    subtitle: 'See who\'s most active this week',
                    isEnabled: true,
                    onTap: () => context.push('/leaderboard'),
                  ),
                  SizedBox(height: 12.h),
                  ExploreCard(
                    icon: Icons.map_outlined,
                    iconColor: const Color(0xFFD6B26A),
                    iconBg: const Color(0xFFF9F5EC),
                    title: 'Uni Graph',
                    subtitle: 'Interactive map of university networks',
                    isEnabled: true,
                    onTap: () => context.push('/uni-graph'),
                  ),
                  SizedBox(height: 12.h),
                  ExploreCard(
                    icon: Icons.account_balance_outlined,
                    iconColor: const Color(0xFF6A98D6),
                    iconBg: const Color(0xFFECF3F9),
                    title: 'Other Universities',
                    subtitle: 'Discover other campus communities',
                    isEnabled: true,
                    onTap: () => context.push('/other-unis'),
                  ),
                ],
              ),
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}
