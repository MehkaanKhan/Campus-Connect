import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';

enum NotificationsFilter { all, comments, carpools, posts }

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
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  NotificationsFilter get filter => _filter;
  int get unreadCount => _all.where((n) => !n.isRead).length;

  List<NotificationEntity> get filtered {
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
    _isLoading = true;
    notifyListeners();
    _all = await _getUsecase();
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(NotificationsFilter f) {
    _filter = f;
    notifyListeners();
  }

  Future<void> markAllRead() async {
    await _markReadUsecase();
    _all = _all.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
