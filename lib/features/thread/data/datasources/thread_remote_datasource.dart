import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/thread_entity.dart';

/// Remote operations for threads (posts) and comments.
abstract class ThreadRemoteDataSource {
  Future<ThreadEntity> getThread(String postId);
  Future<void> postComment(String postId, String content, {String? parentId});
  Future<void> toggleAllowReplies(String postId, bool value);
}

class ThreadRemoteDataSourceImpl implements ThreadRemoteDataSource {
  final SupabaseClient _client;

  ThreadRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<ThreadEntity> getThread(String postId) async {
    final postResponse = await _client.from('posts').select('''
      id,
      title,
      content,
      image_url,
      comment_count,
      allow_replies,
      created_at,
      profiles!author_id (
        full_name,
        avatar_url
      )
    ''').eq('id', postId).maybeSingle();

    if (postResponse == null) {
      throw Exception('Post not found');
    }

    // Fetch comments with author profile data
    final commentsResponse = await _client.from('comments').select('''
      id,
      content,
      upvote_count,
      is_op,
      created_at,
      parent_id,
      profiles!author_id (
        full_name,
        avatar_url
      )
    ''').eq('post_id', postId).order('created_at', ascending: true);

    final authorProfile = postResponse['profiles'] as Map?;
    final authorName = authorProfile?['full_name'] ?? 'Unknown';
    final authorAvatarUrl = authorProfile?['avatar_url'] as String?;
    final createdAt = DateTime.parse(postResponse['created_at']);
    final timeAgo = _formatTimeAgo(createdAt);

    // Build the nested comment tree
    final List<Map<String, dynamic>> allComments =
        List<Map<String, dynamic>>.from(commentsResponse);
    final topLevelComments =
        allComments.where((c) => c['parent_id'] == null).toList();

    List<CommentEntity> mapComments(List<Map<String, dynamic>> nodes) {
      return nodes.map((c) {
        final replies =
            allComments.where((r) => r['parent_id'] == c['id']).toList();
        final cCreatedAt = DateTime.parse(c['created_at']);
        final cProfile = c['profiles'] as Map?;

        return CommentEntity(
          id: c['id'],
          authorName: cProfile?['full_name'] ?? 'Unknown',
          authorAvatarUrl: cProfile?['avatar_url'] as String?,
          timeAgo: _formatTimeAgo(cCreatedAt),
          content: c['content'],
          upvotes: c['upvote_count'],
          isOp: c['is_op'] ?? false,
          replies: mapComments(replies),
        );
      }).toList();
    }

    final mappedComments = mapComments(topLevelComments);

    return ThreadEntity(
      id: postResponse['id'],
      title: postResponse['title'],
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      postedAgo: timeAgo,
      body: postResponse['content'] ?? '',
      imageUrl: postResponse['image_url'] as String?,
      commentCount: postResponse['comment_count'],
      allowReplies: postResponse['allow_replies'],
      comments: mappedComments,
    );
  }

  @override
  Future<void> postComment(String postId, String content, {String? parentId}) async {
    final userId = SupabaseService.uid;
    await _client.from('comments').insert({
      'post_id': postId,
      'author_id': userId,
      'content': content,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  @override
  Future<void> toggleAllowReplies(String postId, bool value) async {
    await _client.from('posts').update({
      'allow_replies': value,
    }).eq('id', postId);
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
