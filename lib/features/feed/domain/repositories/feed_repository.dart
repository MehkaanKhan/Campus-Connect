import '../entities/post_entity.dart';

abstract class FeedRepository {
  Future<List<PostEntity>> getFeed();
  Future<void> insertVote(String postId, String voteType);
  Future<void> deleteVote(String postId);
  Future<void> updateVote(String postId, String voteType);
}
