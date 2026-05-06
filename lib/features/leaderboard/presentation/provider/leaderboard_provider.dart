import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entity.dart';

class LeaderboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LeaderboardEntity> _users = [];
  List<LeaderboardEntity> get users => _users;

  String _currentFilter = 'This Week';
  String get currentFilter => _currentFilter;

  void loadLeaderboard(String filter) async {
    _currentFilter = filter;
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Dummy data based on filter
    _users = _generateDummyData(filter);
    
    _isLoading = false;
    notifyListeners();
  }

  List<LeaderboardEntity> _generateDummyData(String filter) {
    int multiplier = filter == 'This Week' ? 1 : filter == 'This Month' ? 4 : 12;
    return [
      LeaderboardEntity(id: '1', name: 'Zainab Ali', department: 'Software Eng.', score: 1250 * multiplier, avatarUrl: 'Z'),
      LeaderboardEntity(id: '2', name: 'Omar Farooq', department: 'Computer Science', score: 1120 * multiplier, avatarUrl: 'O'),
      LeaderboardEntity(id: '3', name: 'Ayesha Khan', department: 'Data Science', score: 980 * multiplier, avatarUrl: 'A'),
      LeaderboardEntity(id: '4', name: 'Bilal Ahmed', department: 'AI', score: 850 * multiplier, avatarUrl: 'B'),
      LeaderboardEntity(id: '5', name: 'Fatima Noor', department: 'Software Eng.', score: 810 * multiplier, avatarUrl: 'F'),
      LeaderboardEntity(id: '6', name: 'Hassan Raza', department: 'Cyber Security', score: 760 * multiplier, avatarUrl: 'H'),
      LeaderboardEntity(id: '7', name: 'Sara Malik', department: 'Computer Science', score: 710 * multiplier, avatarUrl: 'S'),
      LeaderboardEntity(id: '8', name: 'Usman Tariq', department: 'Information Tech.', score: 650 * multiplier, avatarUrl: 'U'),
      LeaderboardEntity(id: '9', name: 'Hira Shah', department: 'Data Science', score: 600 * multiplier, avatarUrl: 'H'),
      LeaderboardEntity(id: '10', name: 'Ali Zafar', department: 'AI', score: 550 * multiplier, avatarUrl: 'A'),
    ];
  }
}
