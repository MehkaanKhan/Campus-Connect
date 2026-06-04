import '../repositories/create_post_repository.dart';
import '../entities/create_post_entity.dart';

class SubmitPostUsecase {
  final CreatePostRepository repository;
  const SubmitPostUsecase(this.repository);

  Future<String> call(CreatePostEntity post) {
    if (post.title.trim().isEmpty) {
      throw ArgumentError('Post title cannot be empty.');
    }
    return repository.submitPost(post);
  }
}
