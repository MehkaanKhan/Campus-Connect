import '../repositories/notifications_repository.dart';

class MarkAllReadUsecase {
  final NotificationsRepository _repo;
  const MarkAllReadUsecase(this._repo);

  Future<void> call() => _repo.markAllRead();
}
