import '../../domain/entities/create_post_entity.dart';
import '../../domain/repositories/create_post_repository.dart';

class CreatePostLocalDataSourceImpl {
  Future<void> submitPost(CreatePostEntity post) async {
    // TODO: replace with real API / local DB call
    await Future.delayed(const Duration(milliseconds: 400));
  }
}

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostLocalDataSourceImpl localSource;
  const CreatePostRepositoryImpl(this.localSource);

  @override
  Future<void> submitPost(CreatePostEntity post) =>
      localSource.submitPost(post);
}
