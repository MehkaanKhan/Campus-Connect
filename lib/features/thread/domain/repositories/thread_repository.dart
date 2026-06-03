import '../entities/thread_entity.dart';

abstract class ThreadRepository {
  Future<ThreadEntity> getThread(String postId);
  Future<void> postComment(String postId, String content, {String? parentId});
  Future<void> toggleAllowReplies(String postId, bool value);
}
