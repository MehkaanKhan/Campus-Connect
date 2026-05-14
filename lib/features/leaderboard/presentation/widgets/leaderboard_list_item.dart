import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entity.dart';

class LeaderboardListItem extends StatelessWidget {
  final LeaderboardEntity user;
  final int rank;

  const LeaderboardListItem({super.key, required this.user, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF2F2F0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE8EDF8),
            child: Text(
              user.avatarUrl,
              style: const TextStyle(
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  user.department,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: user.score),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return Text(
                '$value pts',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF3B82F6),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
