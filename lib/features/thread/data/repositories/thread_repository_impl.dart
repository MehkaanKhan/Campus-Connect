import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/thread_repository.dart';
import '../datasources/thread_remote_datasource.dart';

class ThreadRepositoryImpl implements ThreadRepository {
  final ThreadRemoteDataSource remoteSource;
  const ThreadRepositoryImpl(this.remoteSource);

  @override
  Future<ThreadEntity> getThread(String postId) => remoteSource.getThread(postId);

  @override
  Future<void> postComment(String postId, String content, {String? parentId}) =>
      remoteSource.postComment(postId, content, parentId: parentId);

  @override
  Future<void> toggleAllowReplies(String postId, bool value) =>
      remoteSource.toggleAllowReplies(postId, value);
}
