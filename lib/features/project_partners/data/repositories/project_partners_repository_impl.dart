import '../../domain/entities/project_application_entity.dart';
import '../../domain/entities/project_partner_entity.dart';
import '../../domain/repositories/project_partners_repository.dart';
import '../datasources/project_partners_remote_datasource.dart';

class ProjectPartnersRepositoryImpl implements ProjectPartnersRepository {
  final ProjectPartnersRemoteDataSource remoteSource;
  const ProjectPartnersRepositoryImpl(this.remoteSource);

  @override
  Future<List<ProjectPartnerEntity>> getProjects({int limit = 10, int offset = 0}) =>
      remoteSource.getProjects(limit: limit, offset: offset);

  @override
  Future<List<String>> getFilterChips() => remoteSource.getFilterChips();

  @override
  Future<void> addProject(ProjectPartnerEntity project) => remoteSource.addProject(project);

  @override
  Future<void> applyToProject(String listingId, String coverMessage, {String? phoneNumber}) =>
      remoteSource.applyToProject(listingId, coverMessage, phoneNumber: phoneNumber);

  @override
  Future<List<ProjectApplicationEntity>> getApplications(String listingId) =>
      remoteSource.getApplications(listingId);

  @override
  Future<void> updateApplicationStatus(String applicationId, String status) =>
      remoteSource.updateApplicationStatus(applicationId, status);
}
