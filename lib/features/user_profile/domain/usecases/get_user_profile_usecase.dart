import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class GetUserProfileUsecase {
  final UserProfileRepository _repo;
  const GetUserProfileUsecase(this._repo);

  Future<UserProfileEntity> call(String userId) => _repo.getProfile(userId);
}
