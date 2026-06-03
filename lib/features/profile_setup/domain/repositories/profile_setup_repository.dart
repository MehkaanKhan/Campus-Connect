import '../entities/profile_setup_entity.dart';
import '../entities/university_entity.dart';

abstract class ProfileSetupRepository {
  Future<List<UniversityEntity>> getUniversities();
  Future<List<String>> getDepartments();
  Future<List<String>> getSemesters();
  Future<void> saveProfile(ProfileSetupEntity profile);
}
