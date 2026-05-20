import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_datasource.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource _source;
  const FeedRepositoryImpl(this._source);

  @override
  Future<List<PostEntity>> getFeed() => _source.getPosts();

  @override
  Future<void> insertVote(String postId, String voteType) =>
      _source.insertVote(postId, voteType);

  @override
  Future<void> deleteVote(String postId) => _source.deleteVote(postId);

  @override
  Future<void> updateVote(String postId, String voteType) =>
      _source.updateVote(postId, voteType);
}
