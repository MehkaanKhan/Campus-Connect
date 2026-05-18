import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

enum BottomNavTab { home, explore, create, alerts, profile }

class CampusBottomNavBar extends StatelessWidget {
  final BottomNavTab activeTab;

  const CampusBottomNavBar({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_outlined,               label: 'HOME',    isActive: activeTab == BottomNavTab.home,    onTap: () => context.go('/feed')),
            _NavItem(icon: Icons.explore_outlined,            label: 'EXPLORE', isActive: activeTab == BottomNavTab.explore, onTap: () => context.go('/explore')),
            _NavItem(icon: Icons.add_circle_outline,          label: 'CREATE',  isActive: activeTab == BottomNavTab.create,  onTap: () => context.go('/create-post')),
            _NavItem(icon: Icons.notifications_none_rounded,  label: 'ALERTS',  isActive: activeTab == BottomNavTab.alerts,  onTap: () => context.go('/notifications')),
            _NavItem(icon: Icons.person_outline_rounded,      label: 'PROFILE', isActive: activeTab == BottomNavTab.profile, onTap: () => context.go('/user-profile')),
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
    final color = isActive ? AppColors.sage : AppColors.navInactive;
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
