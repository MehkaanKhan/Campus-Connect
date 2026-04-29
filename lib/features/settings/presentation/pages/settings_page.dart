import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Change Profile',
            onTap: () => context.push('/settings/profile'),
          ),
          _SettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: Text(
              context.watch<SettingsProvider>().language.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () => context.push('/settings/language'),
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch.adaptive(
              value: context.watch<SettingsProvider>().notificationsEnabled,
              onChanged: (v) => context.read<SettingsProvider>().setNotifications(v),
            ),
            onTap: () => context.push('/settings/notifications'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
