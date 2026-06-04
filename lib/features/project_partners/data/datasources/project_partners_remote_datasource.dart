import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/project_application_entity.dart';
import '../../domain/entities/project_partner_entity.dart';

abstract class ProjectPartnersRemoteDataSource {
  Future<List<ProjectPartnerEntity>> getProjects({int limit = 10, int offset = 0});
  Future<List<String>> getFilterChips();
  Future<void> addProject(ProjectPartnerEntity project);
  Future<void> applyToProject(String listingId, String coverMessage, {String? phoneNumber});
  Future<List<ProjectApplicationEntity>> getApplications(String listingId);
  Future<void> updateApplicationStatus(String applicationId, String status);
}

class ProjectPartnersRemoteDataSourceImpl
    implements ProjectPartnersRemoteDataSource {
  final SupabaseClient _client;

  ProjectPartnersRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<ProjectPartnerEntity>> getProjects({int limit = 10, int offset = 0}) async {
    try {
      final userId = SupabaseService.currentUser?.id;

      // Fetch listings along with their associated skills and applications
      final response = await _client.from('project_listings').select('''
        id,
        creator_id,
        badge,
        badge_color,
        title,
        description,
        project_skills ( skill_name ),
        project_applications ( id, applicant_id, status )
      ''').order('created_at', ascending: false).range(offset, offset + limit - 1);

      return (response as List).map((data) {
        final skillsList = (data['project_skills'] as List?)
                ?.map((s) => s['skill_name'] as String)
                .toList() ??
            [];

        final applications = data['project_applications'] as List? ?? [];
        final applicationCount = applications.length;

        String? currentUserStatus;
        if (userId != null) {
          try {
            final currentUserApp = applications.firstWhere(
              (app) => app['applicant_id'] == userId,
            );
            currentUserStatus = currentUserApp['status'] as String?;
          } catch (_) {
            // No application found for current user
          }
        }

        return ProjectPartnerEntity(
          id: data['id'] as String,
          creatorId: data['creator_id'] as String,
          badge: data['badge'] as String,
          badgeColor: data['badge_color'] as String,
          title: data['title'] as String,
          description: data['description'] as String,
          skills: skillsList,
          applicationCount: applicationCount,
          currentUserApplicationStatus: currentUserStatus,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch project listings: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getFilterChips() async {
    return [
      'All Roles',
      'Computer Science',
      'UI/UX Design',
      'Business',
      'Engineering',
    ];
  }

  @override
  Future<void> addProject(ProjectPartnerEntity project) async {
    if (project.title.trim().isEmpty) {
      throw ArgumentError('Project title cannot be empty.');
    }
    if (project.description.trim().isEmpty) {
      throw ArgumentError('Project description cannot be empty.');
    }
    try {
      final userId = SupabaseService.uid;

      final inserted = await _client.from('project_listings').insert({
        'creator_id': userId,
        'badge': project.badge,
        'badge_color': project.badgeColor,
        'title': project.title,
        'description': project.description,
      }).select('id').single();

      final listingId = inserted['id'] as String;

      if (project.skills.isNotEmpty) {
        final skillRows = project.skills
            .map((skill) => {'listing_id': listingId, 'skill_name': skill})
            .toList();
        await _client.from('project_skills').insert(skillRows);
      }
    } catch (e) {
      throw Exception('Failed to add project listing: ${e.toString()}');
    }
  }

  @override
  Future<void> applyToProject(String listingId, String coverMessage, {String? phoneNumber}) async {
    if (listingId.trim().isEmpty) {
      throw ArgumentError('Listing ID cannot be empty.');
    }
    if (coverMessage.trim().isEmpty) {
      throw ArgumentError('Cover message cannot be empty.');
    }
    try {
      final userId = SupabaseService.uid;
      await _client.from('project_applications').insert({
        'listing_id': listingId,
        'applicant_id': userId,
        'cover_message': coverMessage,
        if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
      });
      _notifyListingCreator(listingId, userId).ignore();
    } catch (e) {
      throw Exception('Failed to submit project application: ${e.toString()}');
    }
  }

  Future<void> _notifyListingCreator(String listingId, String applicantId) async {
    final listing = await _client
        .from('project_listings')
        .select('creator_id, title')
        .eq('id', listingId)
        .maybeSingle();
    if (listing == null) return;
    final creatorId = listing['creator_id'] as String?;
    if (creatorId == null || creatorId == applicantId) return;

    final applicant = await _client
        .from('profiles')
        .select('full_name, avatar_url')
        .eq('id', applicantId)
        .maybeSingle();
    final applicantName = applicant?['full_name'] as String? ?? 'Someone';
    final applicantAvatar = applicant?['avatar_url'] as String?;
    final title = listing['title'] as String? ?? 'your project';

    await _client.from('notifications').insert({
      'user_id': creatorId,
      'type': 'general',
      'message': '$applicantName applied to "$title"',
      'is_read': false,
      'has_action': true,
      'avatar_url': applicantAvatar,
    });
  }

  @override
  Future<List<ProjectApplicationEntity>> getApplications(String listingId) async {
    if (listingId.trim().isEmpty) {
      throw ArgumentError('Listing ID cannot be empty.');
    }
    try {
      final response = await _client.from('project_applications').select('''
        id,
        listing_id,
        applicant_id,
        cover_message,
        phone_number,
        status,
        created_at,
        profiles!applicant_id (
          full_name,
          avatar_url
        )
      ''').eq('listing_id', listingId).order('created_at', ascending: false);

      return (response as List).map((data) {
        final profile = data['profiles'] as Map?;
        final createdAt = DateTime.parse(data['created_at']);
        
        return ProjectApplicationEntity(
          id: data['id'] as String,
          listingId: data['listing_id'] as String,
          applicantId: data['applicant_id'] as String,
          applicantName: profile?['full_name'] ?? 'Unknown',
          applicantAvatarUrl: profile?['avatar_url'] as String?,
          coverMessage: data['cover_message'] as String,
          phoneNumber: data['phone_number'] as String?,
          status: data['status'] as String,
          appliedAgo: _formatTimeAgo(createdAt),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch applications: ${e.toString()}');
    }
  }

  @override
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    if (applicationId.trim().isEmpty) {
      throw ArgumentError('Application ID cannot be empty.');
    }
    try {
      await _client.from('project_applications').update({
        'status': status,
      }).eq('id', applicationId);
    } catch (e) {
      throw Exception('Failed to update application status: ${e.toString()}');
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
