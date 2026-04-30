import '../repositories/project_partners_repository.dart';
import '../entities/project_partner_entity.dart';

class GetProjectPartnersUsecase {
  final ProjectPartnersRepository repository;
  const GetProjectPartnersUsecase(this.repository);

  List<ProjectPartnerEntity> call() => repository.getProjects();
}

class GetFilterChipsUsecase {
  final ProjectPartnersRepository repository;
  const GetFilterChipsUsecase(this.repository);

  List<String> call() => repository.getFilterChips();
}
