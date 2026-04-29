import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final enabled = context.watch<SettingsProvider>().notificationsEnabled;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive app notifications'),
            value: enabled,
            onChanged: (v) => context.read<SettingsProvider>().setNotifications(v),
          ),
          SwitchListTile.adaptive(
            title: const Text('Event Reminders'),
            subtitle: const Text('Get reminded about upcoming events'),
            value: enabled,
            onChanged: enabled ? (v) {} : null,
          ),
          SwitchListTile.adaptive(
            title: const Text('Club Updates'),
            subtitle: const Text('New posts from clubs you follow'),
            value: enabled,
            onChanged: enabled ? (v) {} : null,
          ),
        ],
      ),
    );
  }
}
