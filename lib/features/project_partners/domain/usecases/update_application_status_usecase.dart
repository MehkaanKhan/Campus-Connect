import '../repositories/project_partners_repository.dart';

class UpdateApplicationStatusUsecase {
  final ProjectPartnersRepository _repo;
  const UpdateApplicationStatusUsecase(this._repo);

  Future<void> call(String applicationId, String status) =>
      _repo.updateApplicationStatus(applicationId, status);
}
