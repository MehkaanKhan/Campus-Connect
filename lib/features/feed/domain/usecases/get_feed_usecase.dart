import '../entities/post_entity.dart';
import '../repositories/feed_repository.dart';

class GetFeedUsecase {
  final FeedRepository _repo;
  const GetFeedUsecase(this._repo);

  Future<List<PostEntity>> call() => _repo.getFeed();
}
