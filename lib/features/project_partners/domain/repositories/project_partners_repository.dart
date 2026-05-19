import '../entities/project_partner_entity.dart';

abstract class ProjectPartnersRepository {
  Future<List<ProjectPartnerEntity>> getProjects();
  Future<List<String>> getFilterChips();
  Future<void> addProject(ProjectPartnerEntity project);
}
