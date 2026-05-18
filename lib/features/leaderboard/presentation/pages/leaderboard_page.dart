import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/leaderboard_provider.dart';
import '../widgets/leaderboard_top_card.dart';
import '../widgets/leaderboard_flat_row.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboard('This Week');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: Consumer<LeaderboardProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return const AppLoader();
                if (provider.users.isEmpty) {
                  return Center(
                    child: Text('No rankings yet.',
                        style: TextStyle(fontFamily: 'Inter', color: AppColors.textMuted, fontSize: 13.sp)),
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
                                colors: [AppColors.sage, Color(0xFFB0CFAE)],
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
