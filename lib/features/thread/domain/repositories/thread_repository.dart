import '../entities/thread_entity.dart';

abstract class ThreadRepository {
  ThreadEntity getThread();
  Future<void> postComment(String content);
  Future<void> toggleAllowReplies(bool value);
}
