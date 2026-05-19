import '../entities/thread_entity.dart';
import '../repositories/thread_repository.dart';

class GetThreadUsecase {
  final ThreadRepository repository;
  const GetThreadUsecase(this.repository);

  Future<ThreadEntity> call() => repository.getThread();
}

class PostCommentUsecase {
  final ThreadRepository repository;
  const PostCommentUsecase(this.repository);

  Future<void> call(String content) => repository.postComment(content);
}

class ToggleAllowRepliesUsecase {
  final ThreadRepository repository;
  const ToggleAllowRepliesUsecase(this.repository);

  Future<void> call(bool value) => repository.toggleAllowReplies(value);
}
