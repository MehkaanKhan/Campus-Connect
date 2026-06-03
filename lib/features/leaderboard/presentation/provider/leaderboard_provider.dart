import 'package:flutter/foundation.dart';
import '../../domain/entities/leaderboard_entity.dart';
import '../../domain/usecases/get_leaderboard_usecase.dart';

enum LeaderboardStatus { initial, loading, loaded, error }

class LeaderboardProvider extends ChangeNotifier {
  final GetLeaderboardUsecase _usecase;

  LeaderboardProvider({required GetLeaderboardUsecase usecase}) : _usecase = usecase;

  LeaderboardStatus _status = LeaderboardStatus.initial;
  LeaderboardStatus get status => _status;
  bool get isLoading => _status == LeaderboardStatus.loading;

  List<LeaderboardEntity> _users = [];
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<LeaderboardEntity> get users {
    if (_searchQuery.isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) =>
      u.name.toLowerCase().contains(q) ||
      u.department.toLowerCase().contains(q),
    ).toList();
  }

  String _currentFilter = 'This Week';
  String get currentFilter => _currentFilter;

  String? _error;
  String? get error => _error;

  Future<void> loadLeaderboard(String filter) async {
    _currentFilter = filter;
    _status = LeaderboardStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _users = await _usecase(filter);
      _status = LeaderboardStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = LeaderboardStatus.error;
      _users = [];
    }
    notifyListeners();
  }
}
