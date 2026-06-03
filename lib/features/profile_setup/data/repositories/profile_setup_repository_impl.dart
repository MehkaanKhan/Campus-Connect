import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import '../datasources/profile_setup_remote_datasource.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  final ProfileSetupRemoteDataSource remoteSource;

  const ProfileSetupRepositoryImpl(this.remoteSource);

  @override
  Future<List<UniversityEntity>> getUniversities() => remoteSource.getUniversities();

  @override
  Future<List<String>> getDepartments() => remoteSource.getDepartments();

  @override
  Future<List<String>> getSemesters() => remoteSource.getSemesters();

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) =>
      remoteSource.saveProfile(profile);
}
