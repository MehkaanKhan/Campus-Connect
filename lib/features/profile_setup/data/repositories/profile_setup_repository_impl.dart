import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/entities/university_entity.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import '../datasources/profile_setup_local_datasource.dart';
import '../datasources/profile_setup_remote_datasource.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  final ProfileSetupLocalDataSource localSource;
  final ProfileSetupRemoteDataSource remoteSource;

  const ProfileSetupRepositoryImpl(this.localSource, this.remoteSource);

  @override
  Future<List<UniversityEntity>> getUniversities() => remoteSource.getUniversities();

  @override
  List<String> getDepartments() => localSource.getDepartments();

  @override
  List<String> getSemesters() => localSource.getSemesters();

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) =>
      remoteSource.saveProfile(profile);
}
