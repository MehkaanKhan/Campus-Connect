import '../../domain/entities/notification_entity.dart';

abstract class NotificationsLocalDataSource {
  Future<List<NotificationEntity>> getNotifications();
}

class NotificationsLocalDataSourceImpl implements NotificationsLocalDataSource {
  @override
  Future<List<NotificationEntity>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const NotificationEntity(
        id: '1',
        type: NotificationType.comment,
        message: 'Sarah Jenkins commented on your post: "Is anyone taking Intro to Psych this semester? I need study buddies!"',
        timeAgo: '2m ago',
        isRead: false,
      ),
      const NotificationEntity(
        id: '2',
        type: NotificationType.carpool,
        message: 'Weekend Carpool to City Center has updated their departure time to 4:00 PM.',
        timeAgo: '1h ago',
        isRead: false,
        hasAction: true,
      ),
      const NotificationEntity(
        id: '3',
        type: NotificationType.club,
        message: 'Study Group Alpha added a new post: "Midterm prep materials now available in the shared folder."',
        timeAgo: 'Yesterday',
        isRead: true,
      ),
      const NotificationEntity(
        id: '4',
        type: NotificationType.marketplace,
        message: 'New item matching your alert: "Gently used Drafting Table" was posted in Marketplace.',
        timeAgo: 'Yesterday',
        isRead: true,
      ),
      const NotificationEntity(
        id: '5',
        type: NotificationType.comment,
        message: 'Omar replied to your comment on "Inter-hostel cricket tournament".',
        timeAgo: '2 days ago',
        isRead: true,
      ),
    ];
  }
}
