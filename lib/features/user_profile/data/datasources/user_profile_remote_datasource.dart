import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileEntity> getProfile(String userId);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final SupabaseClient _client;

  UserProfileRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<UserProfileEntity> getProfile(String userId) async {
    final resolvedId = userId == 'me' ? SupabaseService.uid : userId;

    // 1. Profile row
    final profileData = await _client
        .from('profiles')
        .select('id, full_name, department, semester, bio, avatar_url, karma_score')
        .eq('id', resolvedId)
        .single();

    // 2. User's own posts
    final postsData = await _client
        .from('posts')
        .select('id, title, content, flair, upvote_count, comment_count, created_at')
        .eq('author_id', resolvedId)
        .order('created_at', ascending: false);

    // 3. Posts the user has upvoted (reactions)
    final reactedData = await _client
        .from('votes')
        .select('posts(id, title, content, flair, upvote_count, comment_count, created_at)')
        .eq('user_id', resolvedId)
        .eq('vote_type', 'up')
        .not('post_id', 'is', null);

    // 4. Carpools the user has joined (as passenger)
    final carpoolData = await _client
        .from('carpool_passengers')
        .select('carpool_rides(origin, destination)')
        .eq('user_id', resolvedId);

    final posts = (postsData as List).map((p) => _mapPost(p)).toList();

    final reactedPosts = (reactedData as List)
        .where((r) => r['posts'] != null)
        .map((r) => _mapPost(r['posts'] as Map))
        .toList();

    final carpools = (carpoolData as List)
        .where((c) => c['carpool_rides'] != null)
        .map((c) {
          final r = c['carpool_rides'] as Map;
          return '${r['origin']} → ${r['destination']}';
        }).toList();

    return UserProfileEntity(
      id: profileData['id'] as String,
      name: profileData['full_name'] as String? ?? '',
      department: profileData['department'] as String? ?? '',
      year: profileData['semester'] as String? ?? '',
      bio: profileData['bio'] as String? ?? '',
      avatarUrl: profileData['avatar_url'] as String?,
      postCount: posts.length,
      karma: profileData['karma_score'] as int? ?? 0,
      ridesCount: carpools.length,
      posts: posts,
      reactedPosts: reactedPosts,
      joinedCarpools: carpools,
    );
  }

  ProfilePostEntity _mapPost(Map p) => ProfilePostEntity(
        id: p['id'] as String,
        flair: p['flair'] as String? ?? 'General',
        flairColor: _flairHex(p['flair'] as String?),
        title: p['title'] as String? ?? '',
        excerpt: p['content'] as String? ?? '',
        upvotes: p['upvote_count'] as int? ?? 0,
        commentCount: p['comment_count'] as int? ?? 0,
        timeAgo: _formatTimeAgo(DateTime.parse(p['created_at'] as String)),
      );

  String _flairHex(String? flair) {
    switch (flair?.toLowerCase()) {
      case 'events':      return '#D6D6EA';
      case 'academic':    return '#FED9B8';
      case 'hostel':      return '#E2E3E0';
      case 'carpool':     return '#E2E9E0';
      case 'marketplace': return '#D6D6EA';
      default:            return '#E2E3E0';
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
