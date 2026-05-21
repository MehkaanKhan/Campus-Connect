import '../entities/project_application_entity.dart';
import '../repositories/project_partners_repository.dart';

class GetApplicationsUsecase {
  final ProjectPartnersRepository _repo;
  const GetApplicationsUsecase(this._repo);

  Future<List<ProjectApplicationEntity>> call(String listingId) =>
      _repo.getApplications(listingId);
}
