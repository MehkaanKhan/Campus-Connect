import '../entities/university_entity.dart';
import '../repositories/profile_setup_repository.dart';

class GetUniversitiesUsecase {
  final ProfileSetupRepository repository;
  const GetUniversitiesUsecase(this.repository);

  Future<List<UniversityEntity>> call() => repository.getUniversities();
}
