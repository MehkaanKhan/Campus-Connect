import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAllRead();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final SupabaseClient _client;

  NotificationsRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final data = await _client
        .from('notifications')
        .select('id, type, message, is_read, has_action, avatar_url, created_at')
        .eq('user_id', SupabaseService.uid)
        .order('created_at', ascending: false);

    return (data as List).map((n) => NotificationEntity(
      id: n['id'] as String,
      type: _parseType(n['type'] as String?),
      message: n['message'] as String,
      timeAgo: _timeAgo(DateTime.parse(n['created_at'] as String)),
      isRead: n['is_read'] as bool? ?? false,
      hasAction: n['has_action'] as bool? ?? false,
      avatarUrl: n['avatar_url'] as String?,
    )).toList();
  }

  @override
  Future<void> markAllRead() async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', SupabaseService.uid);
  }

  NotificationType _parseType(String? s) {
    switch (s) {
      case 'comment':     return NotificationType.comment;
      case 'carpool':     return NotificationType.carpool;
      case 'club':        return NotificationType.club;
      case 'marketplace': return NotificationType.marketplace;
      default:            return NotificationType.general;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
