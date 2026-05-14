import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/leaderboard_entity.dart';
import '../provider/leaderboard_provider.dart';
import '../../../../core/constants/app_theme.dart';

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
                  return const Center(
                    child: Text('No rankings yet.',
                        style: TextStyle(fontFamily: 'Inter', color: AppColors.textMuted)),
                  );
                }

                final top3 = provider.users.take(3).toList();
                final rest = provider.users.skip(3).toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Page header ─────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [AppColors.sage, Color(0xFFB0CFAE)],
                              ).createShader(bounds),
                              child: const Text(
                                'Weekly Leaderboard',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Top contributors making an impact this week.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      // Accent underline
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 2,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppColors.sage,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Top 3 stacked cards ──────────────────────────────
                      ...List.generate(top3.length, (i) => _TopCard(
                        user: top3[i],
                        rank: i + 1,
                      )),

                      const SizedBox(height: 8),

                      // ── Ranks 4+ table header ────────────────────────────
                      if (rest.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'RANK & USER',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ── Ranks 4+ flat rows ──────────────────────────────
                      ...List.generate(rest.length, (i) => _FlatRow(
                        user: rest[i],
                        rank: i + 4,
                        isLast: i == rest.length - 1,
                      )),

                      // ── View all link ───────────────────────────────────
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {}, // placeholder
                          child: const Text(
                            'VIEW ALL RANKINGS',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: AppColors.sage,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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

// ─────────────────────────────────────────────────────────────────────────────
// Top card (#1, #2, #3) – vertically stacked, progressively smaller
// ─────────────────────────────────────────────────────────────────────────────
class _TopCard extends StatelessWidget {
  final LeaderboardEntity user;
  final int rank;

  const _TopCard({required this.user, required this.rank});

  double get _avatarRadius {
    if (rank == 1) return 44;
    if (rank == 2) return 36;
    return 30;
  }

  double get _nameSize {
    if (rank == 1) return 19;
    if (rank == 2) return 16;
    return 15;
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // ── Coloured top accent bar ──────────────────────────────────
            Container(
              height: 5,
              width: double.infinity,
              color: _accentBar,
            ),
            // ── Card body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: _avatarRadius,
                    backgroundColor: AppColors.darkCardBg,
                    child: Text(
                      user.avatarUrl,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _avatarRadius * 0.7,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rank with emoji
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (rank == 1)
                        const Text('🏅 ', style: TextStyle(fontSize: 14)),
                      Text(
                        '#$rank',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: rank == 1 ? 22 : 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: _nameSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Department / role
                  Text(
                    user.department,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Points badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: _pointsBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_formatScore(user.score)} PTS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
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
    if (score >= 1000) return '${(score / 1000).toStringAsFixed(1).replaceAll('.0', '')},${(score % 1000).toString().padLeft(3, '0')}';
    return '$score';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Flat row for ranks 4 and below
// ─────────────────────────────────────────────────────────────────────────────
class _FlatRow extends StatelessWidget {
  final LeaderboardEntity user;
  final int rank;
  final bool isLast;

  const _FlatRow({required this.user, required this.rank, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 22,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.darkCardBg,
            child: Text(
              user.avatarUrl,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + department
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  user.department.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Points
          Text(
            _formatScore(user.score),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    if (score >= 1000) {
      final thousands = score ~/ 1000;
      final hundreds = score % 1000;
      return '$thousands,${hundreds.toString().padLeft(3, '0')}';
    }
    return '$score';
  }
}
