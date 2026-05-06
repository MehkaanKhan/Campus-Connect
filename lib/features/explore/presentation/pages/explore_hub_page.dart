import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';

class ExploreHubPage extends StatelessWidget {
  const ExploreHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const CampusTopNavBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Discover what\'s happening around campus.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _ExploreCard(
                    icon: Icons.group_outlined,
                    iconColor: const Color(0xFF1E3A8A),
                    iconBg: const Color(0xFFE8EDF8),
                    title: 'Find Project Partners',
                    subtitle: 'Collaborate on projects, startups & research',
                    isEnabled: true,
                    onTap: () => context.push('/project-partners'),
                  ),
                  const SizedBox(height: 12),
                  _ExploreCard(
                    icon: Icons.swap_horiz_rounded,
                    iconColor: const Color(0xFF6B8F6B),
                    iconBg: const Color(0xFFE8F3E8),
                    title: 'Hostellite Exchange',
                    subtitle: 'Borrow, rent or find free items on campus',
                    isEnabled: true,
                    onTap: () => context.push('/hostellite-exchange'),
                  ),
                  const SizedBox(height: 12),
                  _ExploreCard(
                    icon: Icons.directions_car_outlined,
                    iconColor: const Color(0xFFB0A890),
                    iconBg: const Color(0xFFF2F1EE),
                    title: 'Carpool Ride',
                    subtitle: 'Share rides with fellow students',
                    isEnabled: false,
                  ),
                  const SizedBox(height: 12),
                  _ExploreCard(
                    icon: Icons.leaderboard_outlined,
                    iconColor: const Color(0xFFB0A890),
                    iconBg: const Color(0xFFF2F1EE),
                    title: 'Weekly Leaderboard',
                    subtitle: 'See who\'s most active this week',
                    isEnabled: false,
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

class _ExploreCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _ExploreCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isEnabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? onTap
          : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Coming soon!'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEnabled ? const Color(0xFFEEEEE8) : const Color(0xFFF2F2F0),
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isEnabled ? iconBg : const Color(0xFFF2F2F0),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isEnabled ? iconColor : const Color(0xFFBBBBB8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isEnabled ? const Color(0xFF1A1A1A) : const Color(0xFFBBBBB8),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: isEnabled ? const Color(0xFF94A3B8) : const Color(0xFFCCCCCA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isEnabled)
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 22)
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Soon',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
