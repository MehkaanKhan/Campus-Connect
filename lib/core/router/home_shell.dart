import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  static const _tabs = ['/home', '/events', '/clubs', '/profile'];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _tabs.indexWhere((t) => location.startsWith(t));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),         selectedIcon: Icon(Icons.home),         label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_outlined),        selectedIcon: Icon(Icons.event),        label: 'Events'),
          NavigationDestination(icon: Icon(Icons.group_outlined),        selectedIcon: Icon(Icons.group),        label: 'Clubs'),
          NavigationDestination(icon: Icon(Icons.person_outlined),       selectedIcon: Icon(Icons.person),       label: 'Profile'),
        ],
      ),
    );
  }
}
