import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/post_entity.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostEntity>> getPosts();
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final SupabaseClient _client;

  FeedRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<PostEntity>> getPosts() async {
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
    ''').order('created_at', ascending: false);

    return (response as List).map((data) {
      final authorProfile = data['profiles'] as Map?;
      final createdAt = DateTime.parse(data['created_at']);
      
      return PostEntity(
        id: data['id'] as String,
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
      );
    }).toList();
  }

  Color _resolveFlairColor(String? flair) {
    switch (flair?.toLowerCase()) {
      case 'events':      return const Color(0xFFD6D6EA);
      case 'academic':    return const Color(0xFFFED9B8);
      case 'hostel':      return const Color(0xFFE2E3E0);
      case 'carpool':     return const Color(0xFFE2E9E0);
      case 'marketplace': return const Color(0xFFD6D6EA);
      default:            return const Color(0xFFE2E3E0);
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
