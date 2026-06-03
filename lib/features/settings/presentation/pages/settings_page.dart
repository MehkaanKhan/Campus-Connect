import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: ListView(
            controller: ctrl,
            children: const [
              Center(
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Privacy Policy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Inter', color: AppColors.textPrimary)),
              SizedBox(height: 16),
              Text('Last updated: June 2026', style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: 'Inter')),
              SizedBox(height: 16),
              Text('1. Data We Collect', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text('Campus Connect collects your name, university email address, and profile information you choose to provide. We do not sell your personal data to third parties.', style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary, fontFamily: 'Inter')),
              SizedBox(height: 16),
              Text('2. How We Use Your Data', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text('Your data is used solely to provide the Campus Connect experience — connecting students, enabling collaboration, and personalising your feed. We use Supabase for secure data storage.', style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary, fontFamily: 'Inter')),
              SizedBox(height: 16),
              Text('3. Account Deletion', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text('You may request deletion of your account and associated data at any time by contacting support. All personal data will be permanently removed within 30 days.', style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary, fontFamily: 'Inter')),
              SizedBox(height: 16),
              Text('4. Contact', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Inter', color: AppColors.textPrimary)),
              SizedBox(height: 8),
              Text('For privacy inquiries, email: privacy@campusconnect.app', style: TextStyle(fontSize: 13, height: 1.6, color: AppColors.textSecondary, fontFamily: 'Inter')),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Campus Connect', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textMuted)),
            SizedBox(height: 12),
            Text(
              'Campus Connect is a student-first platform for collaboration, resource sharing, and community building across universities.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 13, height: 1.6, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12),
            Text('Built with Flutter & Supabase.', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primary, fontFamily: 'Inter', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

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
            svgAsset: AppAssets.iconProfile,
            title: 'Edit Profile',
            onTap: () => context.push('/settings/profile'),
          ),
          SettingsTile(
            materialIcon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () => context.push('/settings/change-password'),
          ),
          const _SectionHeader('Preferences'),
          SettingsTile(
            svgAsset: AppAssets.iconNotifications,
            title: 'Notifications',
            trailing: Switch.adaptive(
              value: context.watch<SettingsProvider>().notificationsEnabled,
              onChanged: (v) => context.read<SettingsProvider>().setNotifications(v),
            ),
            onTap: () => context.push('/settings/notifications'),
          ),
          SettingsTile(
            materialIcon: Icons.language_outlined,
            title: 'Language',
            trailing: Text(
              context.watch<SettingsProvider>().language.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () => context.push('/settings/language'),
          ),
          const _SectionHeader('More'),
          SettingsTile(
            materialIcon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _showPrivacyPolicy(context),
          ),
          SettingsTile(
            materialIcon: Icons.info_outline,
            title: 'About Campus Connect',
            onTap: () => _showAbout(context),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            materialIcon: Icons.logout,
            title: 'Logout',
            trailing: const SizedBox.shrink(),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Log out?', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  content: const Text('You will be returned to the login screen.', style: TextStyle(fontFamily: 'Inter', color: AppColors.textSecondary)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted, fontFamily: 'Inter')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Log out', style: TextStyle(color: Colors.red, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await context.read<AuthProvider>().logout();
                if (context.mounted) context.go('/login');
              }
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
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
