import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource _source;
  const UserProfileRepositoryImpl(this._source);

  @override
  Future<UserProfileEntity> getProfile(String userId) => _source.getProfile(userId);
}
