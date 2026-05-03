import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum BottomNavTab { home, explore, create, alerts, profile }

class CampusBottomNavBar extends StatelessWidget {
  final BottomNavTab activeTab;

  const CampusBottomNavBar({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEE8), width: 1)),
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
                icon: Icons.home_outlined,
                label: 'HOME',
                isActive: activeTab == BottomNavTab.home,
                onTap: () => context.go('/thread')),
            _NavItem(
                icon: Icons.explore_outlined,
                label: 'EXPLORE',
                isActive: activeTab == BottomNavTab.explore,
                onTap: () => context.go('/project-partners')),
            _NavItem(
                icon: Icons.add_circle_outline,
                label: 'CREATE',
                isActive: activeTab == BottomNavTab.create,
                onTap: () => context.go('/create-post')),
            _NavItem(
                icon: Icons.notifications_none_rounded,
                label: 'ALERTS',
                isActive: activeTab == BottomNavTab.alerts,
                onTap: () {}),
            _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'PROFILE',
                isActive: activeTab == BottomNavTab.profile,
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? const Color(0xFF6B8F6B) : const Color(0xFF999990);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
