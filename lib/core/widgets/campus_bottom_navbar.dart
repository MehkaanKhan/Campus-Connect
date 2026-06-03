import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            _NavItem(svgAsset: 'assets/icons/icons/home.svg',          label: 'HOME',    isActive: activeTab == BottomNavTab.home,    onTap: () => context.go('/feed')),
            _NavItem(svgAsset: 'assets/icons/icons/explore.svg',       label: 'EXPLORE', isActive: activeTab == BottomNavTab.explore, onTap: () => context.go('/explore')),
            _NavItem(svgAsset: 'assets/icons/icons/create.svg',        label: 'CREATE',  isActive: activeTab == BottomNavTab.create,  onTap: () => context.go('/create-post')),
            _NavItem(svgAsset: 'assets/icons/icons/notifications.svg', label: 'ALERTS',  isActive: activeTab == BottomNavTab.alerts,  onTap: () => context.go('/notifications')),
            _NavItem(svgAsset: 'assets/icons/icons/profile.svg',       label: 'PROFILE', isActive: activeTab == BottomNavTab.profile, onTap: () => context.go('/user-profile')),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String svgAsset;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.svgAsset,
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
          SvgPicture.asset(
            svgAsset,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
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
