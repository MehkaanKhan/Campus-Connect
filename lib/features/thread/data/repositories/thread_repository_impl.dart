import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/thread_repository.dart';
import '../datasources/thread_remote_datasource.dart';

class ThreadRepositoryImpl implements ThreadRepository {
  final ThreadRemoteDataSource remoteSource;
  const ThreadRepositoryImpl(this.remoteSource);

  @override
  Future<ThreadEntity> getThread() => remoteSource.getThread('1'); // '1' is stub ID until UI passes real ID

  @override
  Future<void> postComment(String content) =>
      remoteSource.postComment('1', content); // '1' is stub ID

  @override
  Future<void> toggleAllowReplies(bool value) =>
      remoteSource.toggleAllowReplies('1', value); // '1' is stub ID
}
