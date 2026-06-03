import '../repositories/project_partners_repository.dart';
import '../entities/project_partner_entity.dart';

class GetProjectPartnersUsecase {
  final ProjectPartnersRepository repository;
  const GetProjectPartnersUsecase(this.repository);

  Future<List<ProjectPartnerEntity>> call({int limit = 10, int offset = 0}) =>
      repository.getProjects(limit: limit, offset: offset);
}

class GetFilterChipsUsecase {
  final ProjectPartnersRepository repository;
  const GetFilterChipsUsecase(this.repository);

  Future<List<String>> call() => repository.getFilterChips();
}
