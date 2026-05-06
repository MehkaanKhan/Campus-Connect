import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUsecase {
  final NotificationsRepository _repo;
  const GetNotificationsUsecase(this._repo);

  Future<List<NotificationEntity>> call() => _repo.getNotifications();
}
