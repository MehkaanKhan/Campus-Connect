import '../entities/profile_setup_entity.dart';

abstract class ProfileSetupRepository {
  List<String> getDepartments();
  List<String> getSemesters();
  Future<void> saveProfile(ProfileSetupEntity profile);
}
