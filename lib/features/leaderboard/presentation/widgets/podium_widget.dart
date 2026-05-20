import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/leaderboard_entity.dart';

class PodiumWidget extends StatelessWidget {
  final List<LeaderboardEntity> topThree;

  const PodiumWidget({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.length < 3) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PodiumItem(user: topThree[1], rank: 2, height: 120, color: AppColors.silverMedal),
          const SizedBox(width: 10),
          _PodiumItem(user: topThree[0], rank: 1, height: 160, color: AppColors.goldMedal, isFirst: true),
          const SizedBox(width: 10),
          _PodiumItem(user: topThree[2], rank: 3, height: 100, color: AppColors.bronzeMedal),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final LeaderboardEntity user;
  final int rank;
  final double height;
  final Color color;
  final bool isFirst;

  const _PodiumItem({
    required this.user,
    required this.rank,
    required this.height,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: isFirst ? 35 : 28,
              backgroundColor: color,
              child: CircleAvatar(
                radius: isFirst ? 32 : 25,
                backgroundColor: AppColors.navyBlue,
                child: Text(
                  user.avatarUrl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isFirst ? 24 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isFirst)
              Positioned(
                top: -15,
                child: Icon(Icons.star, color: color, size: 30),
              ),
            Positioned(
              bottom: -10,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name.split(' ')[0],
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: isFirst ? FontWeight.w800 : FontWeight.w600,
            fontSize: isFirst ? 14 : 12,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: user.score),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Text(
              '$value pts',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Container(
          width: isFirst ? 80 : 70,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border(
              top: BorderSide(color: color, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}
