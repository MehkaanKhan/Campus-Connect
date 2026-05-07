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
    return [
      LeaderboardEntity(id: '1', name: 'Marcus Thorne',   department: 'Academic Tutor',     score: 12200, avatarUrl: 'M'),
      LeaderboardEntity(id: '2', name: 'Sarah Jenkins',   department: 'Event Organizer',    score: 9450,  avatarUrl: 'S'),
      LeaderboardEntity(id: '3', name: 'Elena Rodriguez', department: 'Marketplace Seller', score: 7900,  avatarUrl: 'E'),
      LeaderboardEntity(id: '4', name: 'David Kim',       department: 'Study Group Lead',   score: 6540,  avatarUrl: 'D'),
      LeaderboardEntity(id: '5', name: 'Aisha Patel',     department: 'Campus Guide',       score: 5890,  avatarUrl: 'A'),
      LeaderboardEntity(id: '6', name: 'James Wilson',    department: 'Tech Support',       score: 5120,  avatarUrl: 'J'),
      LeaderboardEntity(id: '7', name: 'Layla Hassan',    department: 'Peer Mentor',        score: 4780,  avatarUrl: 'L'),
      LeaderboardEntity(id: '8', name: 'Omar Tariq',      department: 'Research Asst.',     score: 4210,  avatarUrl: 'O'),
    ];
  }
}
