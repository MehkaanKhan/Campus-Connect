import '../entities/profile_setup_entity.dart';
import '../repositories/profile_setup_repository.dart';

class SaveProfileUsecase {
  final ProfileSetupRepository repository;
  const SaveProfileUsecase(this.repository);

  Future<void> call(ProfileSetupEntity profile) =>
      repository.saveProfile(profile);
}
