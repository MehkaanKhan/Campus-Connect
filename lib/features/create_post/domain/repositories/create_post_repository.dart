import '../entities/create_post_entity.dart';

abstract class CreatePostRepository {
  Future<String> submitPost(CreatePostEntity post);
}
