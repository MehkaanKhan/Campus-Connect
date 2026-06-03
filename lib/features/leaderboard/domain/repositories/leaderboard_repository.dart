import '../entities/leaderboard_entity.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntity>> getLeaderboard(String filter);
}
