import '../entities/create_post_entity.dart';

abstract class CreatePostRepository {
  Future<void> submitPost(CreatePostEntity post);
}
