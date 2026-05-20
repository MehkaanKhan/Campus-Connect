import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _source;
  const NotificationsRepositoryImpl(this._source);

  @override
  Future<List<NotificationEntity>> getNotifications() => _source.getNotifications();

  @override
  Future<void> markAllRead() => _source.markAllRead();
}
