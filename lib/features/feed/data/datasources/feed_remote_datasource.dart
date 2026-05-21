import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/post_entity.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostEntity>> getPosts();
  Future<void> insertVote(String postId, String voteType);
  Future<void> deleteVote(String postId);
  Future<void> updateVote(String postId, String voteType);
  Future<String> getUniversityName();
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final SupabaseClient _client;

  FeedRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<String> getUniversityName() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return 'Your Campus';

    final res = await _client
        .from('profiles')
        .select('universities(name, logo_text)')
        .eq('id', userId)
        .maybeSingle();

    if (res != null && res['universities'] != null) {
      final uniData = res['universities'] as Map<String, dynamic>;
      final logoText = uniData['logo_text'] as String?;
      if (logoText != null && logoText.trim().isNotEmpty) {
        return logoText;
      }
      return uniData['name'] as String;
    }
    return 'Your Campus';
  }

  @override
  Future<List<PostEntity>> getPosts() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Resolve the current user's university so we can scope the feed
    final profileRow = await _client
        .from('profiles')
        .select('university_id')
        .eq('id', userId)
        .maybeSingle();

    final universityId = profileRow?['university_id'] as String?;
    if (universityId == null || universityId.isEmpty) {
      throw Exception(
        'Please complete your profile setup and select your university to see your campus feed.',
      );
    }

    final response = await _client.from('posts').select('''
      id,
      title,
      content,
      image_url,
      flair,
      upvote_count,
      downvote_count,
      comment_count,
      created_at,
      profiles!author_id (
        full_name,
        avatar_url
      )
    ''')
        .eq('university_id', universityId)
        .order('created_at', ascending: false);

    final posts = response as List;

    // Batch-fetch the current user's votes for all these posts in one query
    final Map<String, String> userVotes = {};
    if (posts.isNotEmpty) {
      final postIds = posts.map((p) => p['id'] as String).toList();
      final votesResponse = await _client
          .from('votes')
          .select('post_id, vote_type')
          .eq('user_id', userId)
          .inFilter('post_id', postIds);
      for (final v in votesResponse as List) {
        userVotes[v['post_id'] as String] = v['vote_type'] as String;
      }
    }

    return posts.map((data) {
      final authorProfile = data['profiles'] as Map?;
      final createdAt = DateTime.parse(data['created_at']);
      final postId = data['id'] as String;

      return PostEntity(
        id: postId,
        authorName: authorProfile?['full_name'] ?? 'Unknown',
        authorAvatarUrl: authorProfile?['avatar_url'] as String?,
        timeAgo: _formatTimeAgo(createdAt),
        flair: data['flair'] ?? 'General',
        flairColor: _resolveFlairColor(data['flair']),
        title: data['title'] ?? '',
        excerpt: data['content'] ?? '',
        imageUrl: data['image_url'] as String?,
        upvotes: data['upvote_count'] ?? 0,
        downvotes: data['downvote_count'] ?? 0,
        commentCount: data['comment_count'] ?? 0,
        isUpvoted: userVotes[postId] == 'up',
        isDownvoted: userVotes[postId] == 'down',
      );
    }).toList();
  }

  @override
  Future<void> insertVote(String postId, String voteType) async {
    await _client.from('votes').insert({
      'user_id': SupabaseService.uid,
      'post_id': postId,
      'vote_type': voteType,
    });
  }

  @override
  Future<void> deleteVote(String postId) async {
    await _client
        .from('votes')
        .delete()
        .eq('user_id', SupabaseService.uid)
        .eq('post_id', postId);
  }

  @override
  Future<void> updateVote(String postId, String voteType) async {
    await _client
        .from('votes')
        .update({'vote_type': voteType})
        .eq('user_id', SupabaseService.uid)
        .eq('post_id', postId);
  }

  Color _resolveFlairColor(String? flair) {
    switch (flair?.toLowerCase()) {
      case 'events':      return AppColors.flairEvents;
      case 'academic':    return AppColors.flairAcademic;
      case 'hostel':      return AppColors.flairHostel;
      case 'carpool':     return AppColors.flairCarpool;
      case 'marketplace': return AppColors.flairMarketplace;
      default:            return AppColors.flairHostel;
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
