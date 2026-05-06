import '../entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<UserProfileEntity> getProfile(String userId);
}
