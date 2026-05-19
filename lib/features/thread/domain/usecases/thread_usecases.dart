import '../entities/thread_entity.dart';
import '../repositories/thread_repository.dart';

class GetThreadUsecase {
  final ThreadRepository repository;
  const GetThreadUsecase(this.repository);

  Future<ThreadEntity> call(String postId) => repository.getThread(postId);
}

class PostCommentUsecase {
  final ThreadRepository repository;
  const PostCommentUsecase(this.repository);

  Future<void> call(String postId, String content) => repository.postComment(postId, content);
}

class ToggleAllowRepliesUsecase {
  final ThreadRepository repository;
  const ToggleAllowRepliesUsecase(this.repository);

  Future<void> call(String postId, bool value) => repository.toggleAllowReplies(postId, value);
}
