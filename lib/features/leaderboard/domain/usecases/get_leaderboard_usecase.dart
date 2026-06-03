import '../entities/leaderboard_entity.dart';
import '../repositories/leaderboard_repository.dart';

class GetLeaderboardUsecase {
  final LeaderboardRepository _repo;

  GetLeaderboardUsecase(this._repo);

  Future<List<LeaderboardEntity>> call(String filter) => _repo.getLeaderboard(filter);
}
