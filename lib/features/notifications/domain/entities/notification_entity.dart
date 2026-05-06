enum NotificationType { comment, carpool, club, marketplace, general }

class NotificationEntity {
  final String id;
  final NotificationType type;
  final String message;
  final String timeAgo;
  final bool isRead;
  final bool hasAction;
  final String? avatarUrl;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
    this.hasAction = false,
    this.avatarUrl,
  });

  NotificationEntity copyWith({bool? isRead}) => NotificationEntity(
        id: id,
        type: type,
        message: message,
        timeAgo: timeAgo,
        isRead: isRead ?? this.isRead,
        hasAction: hasAction,
        avatarUrl: avatarUrl,
      );
}
