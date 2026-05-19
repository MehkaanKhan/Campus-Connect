import '../entities/project_partner_entity.dart';
import '../repositories/project_partners_repository.dart';

class AddProjectPartnerUseCase {
  final ProjectPartnersRepository repository;

  const AddProjectPartnerUseCase(this.repository);

  Future<void> call(ProjectPartnerEntity project) async {
    return repository.addProject(project);
  }
}
