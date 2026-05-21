import '../entities/project_application_entity.dart';
import '../entities/project_partner_entity.dart';

abstract class ProjectPartnersRepository {
  Future<List<ProjectPartnerEntity>> getProjects();
  Future<List<String>> getFilterChips();
  Future<void> addProject(ProjectPartnerEntity project);

  /// Submit an application to a project listing.
  Future<void> applyToProject(String listingId, String coverMessage, {String? phoneNumber});

  /// Fetch all applications for a listing (creator only).
  Future<List<ProjectApplicationEntity>> getApplications(String listingId);

  /// Accept or reject an application (creator only).
  Future<void> updateApplicationStatus(String applicationId, String status);
}
