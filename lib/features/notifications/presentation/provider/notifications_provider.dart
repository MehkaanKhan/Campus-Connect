import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';

enum NotificationsFilter { all, comments, carpools, posts }
enum NotificationsStatus { initial, loading, loaded, error }

class NotificationsProvider extends ChangeNotifier {
  final GetNotificationsUsecase _getUsecase;
  final MarkAllReadUsecase _markReadUsecase;

  NotificationsProvider({
    required GetNotificationsUsecase getUsecase,
    required MarkAllReadUsecase markReadUsecase,
  })  : _getUsecase = getUsecase,
        _markReadUsecase = markReadUsecase;

  List<NotificationEntity> _all = [];
  NotificationsFilter _filter = NotificationsFilter.all;
  NotificationsStatus _status = NotificationsStatus.initial;
  String? _error;

  NotificationsStatus get status => _status;
  bool get isLoading => _status == NotificationsStatus.loading;
  String? get error => _error;
  NotificationsFilter get filter => _filter;
  int get unreadCount => _all.where((n) => !n.isRead).length; // live -> acounted directly from all

  List<NotificationEntity> get filtered { //  you never need to remember to re-filter after marking as read — it's always correct.
    switch (_filter) {
      case NotificationsFilter.comments:
        return _all.where((n) => n.type == NotificationType.comment).toList();
      case NotificationsFilter.carpools:
        return _all.where((n) => n.type == NotificationType.carpool).toList();
      case NotificationsFilter.posts:
        return _all.where((n) => n.type == NotificationType.club || n.type == NotificationType.general).toList();
      case NotificationsFilter.all:
        return _all;
    }
  }

  Future<void> load() async {
    _status = NotificationsStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _all = await _getUsecase();
      _status = NotificationsStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = NotificationsStatus.error;
    }
    notifyListeners();
  }

  void setFilter(NotificationsFilter f) {
    _filter = f;
    notifyListeners();
  }

  Future<void> markAllRead() async { // creates a new list of object read
    await _markReadUsecase();
    _all = _all.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
