import '../repositories/create_post_repository.dart';
import '../entities/create_post_entity.dart';

class SubmitPostUsecase {
  final CreatePostRepository repository;
  const SubmitPostUsecase(this.repository);

  Future<void> call(CreatePostEntity post) => repository.submitPost(post);
}
