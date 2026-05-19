import '../../domain/entities/project_partner_entity.dart';
import '../../domain/repositories/project_partners_repository.dart';
import '../datasources/project_partners_remote_datasource.dart';

class ProjectPartnersRepositoryImpl implements ProjectPartnersRepository {
  final ProjectPartnersRemoteDataSource remoteSource;
  const ProjectPartnersRepositoryImpl(this.remoteSource);

  @override
  Future<List<ProjectPartnerEntity>> getProjects() => remoteSource.getProjects();

  @override
  Future<List<String>> getFilterChips() => remoteSource.getFilterChips();
}
