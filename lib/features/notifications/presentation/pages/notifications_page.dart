import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/notification_entity.dart';
import '../provider/notifications_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const CampusTopNavBar(),
          _NotificationsHeader(),
          _FilterRow(),
          Expanded(child: _NotificationsList()),
          const CampusBottomNavBar(activeTab: BottomNavTab.alerts),
        ],
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.read<NotificationsProvider>().markAllRead(),
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B8F6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  static const _filters = [
    (NotificationsFilter.all, 'All'),
    (NotificationsFilter.comments, 'Comments'),
    (NotificationsFilter.carpools, 'Carpools'),
    (NotificationsFilter.posts, 'Posts'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<NotificationsProvider>().filter;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final isActive = current == f.$1;
            return GestureDetector(
              onTap: () => context.read<NotificationsProvider>().setFilter(f.$1),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF98A895) : const Color(0xFFF2F3F0),
                  borderRadius: BorderRadius.circular(20),
                  border: isActive ? null : Border.all(color: const Color(0xFFE2E3E0)),
                ),
                child: Text(
                  f.$2,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF434942),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    if (provider.isLoading) return const AppLoader();
    final items = provider.filtered;
    if (items.isEmpty) {
      return const Center(
        child: Text('No notifications', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFEEEEE8)),
      itemBuilder: (ctx, i) => _NotificationTile(item: items[i]),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  const _NotificationTile({required this.item});

  IconData get _icon {
    switch (item.type) {
      case NotificationType.comment:  return Icons.chat_bubble_outline;
      case NotificationType.carpool:  return Icons.directions_car_outlined;
      case NotificationType.club:     return Icons.group_outlined;
      case NotificationType.marketplace: return Icons.storefront_outlined;
      case NotificationType.general:  return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead ? Colors.white : const Color(0xFFF0F7F0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFE2E9E0),
            child: Icon(_icon, size: 18, color: const Color(0xFF6B8F6B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: const Color(0xFF1A1A1A),
                    fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.timeAgo,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                if (item.hasAction) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF98A895),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6B8F6B),
              ),
            ),
        ],
      ),
    );
  }
}
