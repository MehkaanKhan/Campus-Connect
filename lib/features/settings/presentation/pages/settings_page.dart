import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.cardBg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const _SectionHeader('Account'),
          SettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {},
          ),
          const _SectionHeader('Preferences'),
          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch.adaptive(
              value: context.watch<SettingsProvider>().notificationsEnabled,
              onChanged: (v) => context.read<SettingsProvider>().setNotifications(v),
            ),
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: Text(
              context.watch<SettingsProvider>().language.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () {},
          ),
          const _SectionHeader('More'),
          SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About Campus Connect',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            trailing: const SizedBox.shrink(),
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
