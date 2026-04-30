import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import '../datasources/profile_setup_local_datasource.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  final ProfileSetupLocalDataSource localSource;

  const ProfileSetupRepositoryImpl(this.localSource);

  @override
  List<String> getDepartments() => localSource.getDepartments();

  @override
  List<String> getSemesters() => localSource.getSemesters();

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) =>
      localSource.saveProfile(profile);
}
