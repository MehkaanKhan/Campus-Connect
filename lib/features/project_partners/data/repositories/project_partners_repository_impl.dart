import '../../domain/entities/project_partner_entity.dart';
import '../../domain/repositories/project_partners_repository.dart';
import '../datasources/project_partners_local_datasource.dart';

class ProjectPartnersRepositoryImpl implements ProjectPartnersRepository {
  final ProjectPartnersLocalDataSource localSource;
  const ProjectPartnersRepositoryImpl(this.localSource);

  @override
  List<ProjectPartnerEntity> getProjects() => localSource.getProjects();

  @override
  List<String> getFilterChips() => localSource.getFilterChips();
}
