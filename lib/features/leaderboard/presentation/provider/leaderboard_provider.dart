import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/leaderboard_entity.dart';

class LeaderboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<LeaderboardEntity> _users = [];
  List<LeaderboardEntity> get users => _users;

  String _currentFilter = 'This Week';
  String get currentFilter => _currentFilter;

  Future<void> loadLeaderboard(String filter) async {
    _currentFilter = filter;
    _isLoading = true;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select('id, full_name, department, karma_score')
          .order('karma_score', ascending: false)
          .limit(20);

      _users = (data as List).map((p) {
        final name = p['full_name'] as String? ?? 'Unknown';
        return LeaderboardEntity(
          id: p['id'] as String,
          name: name,
          department: p['department'] as String? ?? '',
          score: p['karma_score'] as int? ?? 0,
          avatarUrl: name.isNotEmpty ? name[0].toUpperCase() : 'U',
        );
      }).toList();
    } on PostgrestException catch (e) {
      debugPrint('Leaderboard error: ${e.message}');
      _users = [];
    } catch (e) {
      debugPrint('Leaderboard error: $e');
      _users = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
