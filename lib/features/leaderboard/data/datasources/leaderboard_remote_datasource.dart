import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/leaderboard_entity.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardEntity>> getLeaderboard(String filter);
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final SupabaseClient _client;

  LeaderboardRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<LeaderboardEntity>> getLeaderboard(String filter) async {
    DateTime? cutoff;
    if (filter == 'This Week') {
      cutoff = DateTime.now().subtract(const Duration(days: 7));
    } else if (filter == 'This Month') {
      cutoff = DateTime.now().subtract(const Duration(days: 30));
    }

    List<String>? activeUserIds;
    if (cutoff != null) {
      final posts = await _client
          .from('posts')
          .select('author_id')
          .gte('created_at', cutoff.toIso8601String());

      activeUserIds = (posts as List)
          .map((p) => p['author_id'] as String)
          .toSet()
          .toList();

      if (activeUserIds.isEmpty) return [];
    }

    var query = _client
        .from('profiles')
        .select('id, full_name, department, karma_score');

    if (activeUserIds != null) {
      query = query.inFilter('id', activeUserIds);
    }

    final data = await query
        .order('karma_score', ascending: false)
        .limit(20);

    return (data as List).map((p) {
      final name = p['full_name'] as String? ?? 'Unknown';
      return LeaderboardEntity(
        id: p['id'] as String,
        name: name,
        department: p['department'] as String? ?? '',
        score: p['karma_score'] as int? ?? 0,
        avatarUrl: name.isNotEmpty ? name[0].toUpperCase() : 'U',
      );
    }).toList();
  }
}
