import '../repositories/feed_repository.dart';

class GetUniversityNameUsecase {
  final FeedRepository _repo;
  const GetUniversityNameUsecase(this._repo);

  Future<String> call() => _repo.getUniversityName();
}
