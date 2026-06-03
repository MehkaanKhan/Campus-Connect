import '../../domain/entities/leaderboard_entity.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_remote_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource _datasource;

  LeaderboardRepositoryImpl(this._datasource);

  @override
  Future<List<LeaderboardEntity>> getLeaderboard(String filter) =>
      _datasource.getLeaderboard(filter);
}
