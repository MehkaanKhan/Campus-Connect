import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_local_datasource.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedLocalDataSource _source;
  const FeedRepositoryImpl(this._source);

  @override
  Future<List<PostEntity>> getFeed() => _source.getPosts();
}
