import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/thread_repository.dart';
import '../datasources/thread_remote_datasource.dart';

class ThreadRepositoryImpl implements ThreadRepository {
  final ThreadRemoteDataSource remoteSource;
  const ThreadRepositoryImpl(this.remoteSource);

  @override
  Future<ThreadEntity> getThread(String postId) => remoteSource.getThread(postId);

  @override
  Future<void> postComment(String postId, String content) =>
      remoteSource.postComment(postId, content);

  @override
  Future<void> toggleAllowReplies(String postId, bool value) =>
      remoteSource.toggleAllowReplies(postId, value);
}
