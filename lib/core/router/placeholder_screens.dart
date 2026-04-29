import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/logout.dart';

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const _PlaceholderBody(title: 'Home', icon: Icons.home);
}

class EventsPlaceholder extends StatelessWidget {
  const EventsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const _PlaceholderBody(title: 'Events', icon: Icons.event);
}

class ClubsPlaceholder extends StatelessWidget {
  const ClubsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const _PlaceholderBody(title: 'Clubs', icon: Icons.group);
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});
  @override
  Widget build(BuildContext context) => const LogoutPage();
}

class _PlaceholderBody extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderBody({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('$title coming soon', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
