import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/create_post_entity.dart';

/// Abstract interface for post creation data operations.
abstract class CreatePostRemoteDataSource {
  Future<void> submitPost(CreatePostEntity post);
}

/// Supabase implementation — inserts into `posts` table,
/// uploads images to `post-images` bucket, and inserts tags into `post_tags`.
class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final SupabaseClient _client;

  CreatePostRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<void> submitPost(CreatePostEntity post) async {
    final userId = SupabaseService.uid;

    // Resolve the user's university_id from their profile
    final profile = await _client
        .from('profiles')
        .select('university_id')
        .eq('id', userId)
        .single();

    // Upload image if provided
    String? imageUrl;
    if (post.imagePath != null && post.imagePath!.isNotEmpty) {
      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await SupabaseService.postImagesBucket.uploadBinary(
        filePath,
        Uint8List(0), // placeholder — real bytes come from the UI layer
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      imageUrl = SupabaseService.postImagesBucket.getPublicUrl(filePath);
    }

    // Insert the post
    final inserted = await _client.from('posts').insert({
      'author_id': userId,
      'university_id': profile['university_id'],
      'title': post.title,
      'content': post.content,
      'image_url': imageUrl,
      'flair': post.tags.isNotEmpty ? post.tags.first : 'General',
    }).select('id').single();

    // Insert tags
    if (post.tags.isNotEmpty) {
      final tagRows = post.tags
          .map((tag) => {'post_id': inserted['id'], 'tag': tag})
          .toList();
      await _client.from('post_tags').insert(tagRows);
    }
  }
}
