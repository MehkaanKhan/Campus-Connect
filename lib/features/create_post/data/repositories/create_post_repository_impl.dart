import '../../domain/entities/create_post_entity.dart';
import '../../domain/repositories/create_post_repository.dart';
import '../datasources/create_post_remote_datasource.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final CreatePostRemoteDataSource remoteSource;
  const CreatePostRepositoryImpl(this.remoteSource);

  @override
  Future<String> submitPost(CreatePostEntity post) =>
      remoteSource.submitPost(post);
}
