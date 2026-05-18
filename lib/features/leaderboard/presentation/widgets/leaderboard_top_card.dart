import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/leaderboard_entity.dart';

class LeaderboardTopCard extends StatelessWidget {
  final LeaderboardEntity user;
  final int rank;

  const LeaderboardTopCard({super.key, required this.user, required this.rank});

  double get _avatarRadius {
    if (rank == 1) return 44.r;
    if (rank == 2) return 36.r;
    return 30.r;
  }

  double get _nameSize {
    if (rank == 1) return 19.sp;
    if (rank == 2) return 16.sp;
    return 15.sp;
  }

  Color get _pointsBg {
    if (rank == 1) return AppColors.sageDark;
    if (rank == 2) return AppColors.rank2BadgeBg;
    return AppColors.rank3BadgeBg;
  }

  Color get _pointsText {
    if (rank == 1) return Colors.white;
    if (rank == 2) return AppColors.rank2BadgeText;
    return AppColors.sage;
  }

  Color get _accentBar {
    if (rank == 1) return AppColors.rank1Accent;
    if (rank == 2) return AppColors.rank2Accent;
    return AppColors.rank3Accent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Column(
          children: [
            Container(
              height: 5.h,
              width: double.infinity,
              color: _accentBar,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: _avatarRadius,
                    backgroundColor: AppColors.darkCardBg,
                    child: Text(
                      user.avatarUrl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (rank == 1 ? 44 : rank == 2 ? 36 : 30).toDouble().sp * 0.7,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (rank == 1)
                        const Text('🏅 ', style: TextStyle(fontSize: 14)),
                      Text(
                        '#$rank',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: rank == 1 ? 22.sp : 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _nameSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    user.department,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: _pointsBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_formatScore(user.score)} PTS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: _pointsText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatScore(int score) {
    if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1).replaceAll('.0', '')},${(score % 1000).toString().padLeft(3, '0')}';
    }
    return '$score';
  }
}
