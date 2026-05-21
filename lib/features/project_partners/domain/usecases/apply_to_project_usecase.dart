import '../repositories/project_partners_repository.dart';

class ApplyToProjectUsecase {
  final ProjectPartnersRepository _repo;
  const ApplyToProjectUsecase(this._repo);

  Future<void> call(String listingId, String coverMessage, {String? phoneNumber}) {
    return _repo.applyToProject(listingId, coverMessage, phoneNumber: phoneNumber);
  }
}
