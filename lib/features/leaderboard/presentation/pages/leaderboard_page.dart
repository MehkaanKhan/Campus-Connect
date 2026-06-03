import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../provider/leaderboard_provider.dart';
import '../widgets/leaderboard_shimmer.dart';
import '../widgets/leaderboard_top_card.dart';
import '../widgets/leaderboard_flat_row.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboard('This Week');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => Navigator.of(context).pop()),
          Container(
            color: AppColors.cardBg,
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => context.read<LeaderboardProvider>().search(val),
              decoration: InputDecoration(
                hintText: 'Search by name or department...',
                prefixIcon: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset(AppAssets.iconSearch, width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn))),
                filled: true,
                fillColor: AppColors.filterInactiveBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Consumer<LeaderboardProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return const LeaderboardShimmer();
                if (provider.status == LeaderboardStatus.error) {
                  return ErrorState(
                    message: provider.error,
                    onRetry: () => context.read<LeaderboardProvider>().loadLeaderboard(provider.currentFilter),
                  );
                }
                if (provider.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events_outlined, size: 48.w, color: AppColors.imagePlaceholder),
                        SizedBox(height: 12.h),
                        Text(
                          provider.searchQuery.isEmpty ? 'No rankings yet' : 'No users found',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          provider.searchQuery.isEmpty ? 'Start posting to earn karma points!' : 'Try a different name or department',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                final top3 = provider.users.take(3).toList();
                final rest = provider.users.skip(3).toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [AppColors.sage, AppColors.sageGradientEnd],
                              ).createShader(bounds),
                              child: Text(
                                'Weekly Leaderboard',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Top contributors making an impact this week.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        height: 2.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ...List.generate(top3.length, (i) => LeaderboardTopCard(
                        user: top3[i],
                        rank: i + 1,
                      )),
                      SizedBox(height: 8.h),
                      if (rest.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'RANK & USER',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              Text(
                                'POINTS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ...List.generate(rest.length, (i) => LeaderboardFlatRow(
                        user: rest[i],
                        rank: i + 4,
                        isLast: i == rest.length - 1,
                      )),
                      SizedBox(height: 20.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'VIEW ALL RANKINGS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: AppColors.sage,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                );
              },
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}
