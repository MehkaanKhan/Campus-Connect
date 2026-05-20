import '../repositories/feed_repository.dart';

class VoteOnPostUsecase {
  final FeedRepository _repo;
  VoteOnPostUsecase(this._repo);

  Future<void> insert(String postId, String voteType) =>
      _repo.insertVote(postId, voteType);

  Future<void> delete(String postId) => _repo.deleteVote(postId);

  Future<void> update(String postId, String voteType) =>
      _repo.updateVote(postId, voteType);
}
