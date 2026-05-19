import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/thread_entity.dart';


/// Remote operations for threads (posts) and comments.
abstract class ThreadRemoteDataSource {
  Future<ThreadEntity> getThread(String postId);
  Future<void> postComment(String postId, String content);
  Future<void> toggleAllowReplies(String postId, bool value);
}

class ThreadRemoteDataSourceImpl implements ThreadRemoteDataSource {
  final SupabaseClient _client;

  ThreadRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<ThreadEntity> getThread(String postId) async {
    // We use a mock ID if the app currently doesn't pass one properly yet
    // because the UI might be hardcoded to just show a "thread".
    // For now, let's fetch a specific post if the ID is real, or just the latest post.
    
    // Attempt to fetch the post, author profile, and its comments (and comment authors)
    // Supabase can query nested relations like: comments(id, content, upvote_count, is_op, created_at, profiles(full_name))
    final postResponse = await _client.from('posts').select('''
      id,
      title,
      content,
      comment_count,
      allow_replies,
      created_at,
      profiles!author_id (full_name)
    ''').eq('id', postId).maybeSingle();

    if (postResponse == null) {
      throw Exception('Post not found');
    }

    // Now fetch comments explicitly to sort them and get author names
    final commentsResponse = await _client.from('comments').select('''
      id,
      content,
      upvote_count,
      is_op,
      created_at,
      parent_id,
      profiles!author_id (full_name)
    ''').eq('post_id', postId).order('created_at', ascending: true);

    final authorName = postResponse['profiles']?['full_name'] ?? 'Unknown';
    final createdAt = DateTime.parse(postResponse['created_at']);
    final timeAgo = _formatTimeAgo(createdAt);

    // Build the nested comment structure
    // Since the current entity supports replies, we build a tree.
    final List<Map<String, dynamic>> allComments = List<Map<String, dynamic>>.from(commentsResponse);
    final topLevelComments = allComments.where((c) => c['parent_id'] == null).toList();

    List<CommentEntity> mapComments(List<Map<String, dynamic>> commentNodes) {
      return commentNodes.map((c) {
        final replies = allComments.where((reply) => reply['parent_id'] == c['id']).toList();
        final cCreatedAt = DateTime.parse(c['created_at']);
        
        return CommentEntity(
          id: c['id'],
          authorName: c['profiles']?['full_name'] ?? 'Unknown',
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
      postedAgo: timeAgo,
      body: postResponse['content'],
      commentCount: postResponse['comment_count'],
      allowReplies: postResponse['allow_replies'],
      comments: mappedComments,
    );
  }

  @override
  Future<void> postComment(String postId, String content) async {
    final userId = SupabaseService.uid;
    await _client.from('comments').insert({
      'post_id': postId,
      'author_id': userId,
      'content': content,
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
