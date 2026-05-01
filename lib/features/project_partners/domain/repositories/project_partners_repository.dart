import '../entities/project_partner_entity.dart';

abstract class ProjectPartnersRepository {
  List<ProjectPartnerEntity> getProjects();
  List<String> getFilterChips();
}
