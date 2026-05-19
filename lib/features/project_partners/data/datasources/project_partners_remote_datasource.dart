import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/project_partner_entity.dart';

/// Remote operations for project partners — backed by `project_listings`
/// and `project_skills` tables.
abstract class ProjectPartnersRemoteDataSource {
  Future<List<ProjectPartnerEntity>> getProjects();
  Future<List<String>> getFilterChips();
}

class ProjectPartnersRemoteDataSourceImpl
    implements ProjectPartnersRemoteDataSource {
  final SupabaseClient _client;

  ProjectPartnersRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<ProjectPartnerEntity>> getProjects() async {
    // Fetch listings along with their associated skills
    final response = await _client.from('project_listings').select('''
      id,
      badge,
      badge_color,
      title,
      description,
      project_skills ( skill_name )
    ''').order('created_at', ascending: false);

    return (response as List).map((data) {
      final skillsList = (data['project_skills'] as List?)
          ?.map((s) => s['skill_name'] as String)
          .toList() ?? [];

      return ProjectPartnerEntity(
        id: data['id'] as String,
        badge: data['badge'] as String,
        badgeColor: data['badge_color'] as String,
        title: data['title'] as String,
        description: data['description'] as String,
        skills: skillsList,
      );
    }).toList();
  }

  @override
  Future<List<String>> getFilterChips() async {
    // In a real implementation, this might query distinct roles or be static.
    // We keep the static ones that the user's local datasource had to match the UI.
    return [
      'All Roles',
      'Computer Science',
      'UI/UX Design',
      'Business',
      'Engineering',
    ];
  }
}
