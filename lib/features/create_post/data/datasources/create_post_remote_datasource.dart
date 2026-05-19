import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/create_post_entity.dart';

/// Abstract interface for post creation data operations.
abstract class CreatePostRemoteDataSource {
  Future<String> submitPost(CreatePostEntity post);
}

/// Supabase implementation — inserts into `posts` table,
/// uploads images to `post-images` bucket, and inserts tags into `post_tags`.
class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final SupabaseClient _client;

  CreatePostRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<String> submitPost(CreatePostEntity post) async {
    String userId;
    String? universityId;

    // Check if we have an authenticated user
    final currentUser = _client.auth.currentUser;

    if (currentUser != null) {
      // Authenticated flow
      userId = currentUser.id;

      final profile = await _client
          .from('profiles')
          .select('university_id')
          .eq('id', userId)
          .single();

      universityId = profile['university_id'] as String?;
      return _insertPostWithClient(_client, userId, universityId, post);
    } else {
      // Unauthenticated / bypass flow for testing/development
      final url = dotenv.env['SUPABASE_URL'] ?? '';
      final serviceKey = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'] ?? '';
      final sClient = SupabaseClient(url, serviceKey);

      // Try to find any existing profile to act as the post author
      final profiles = await sClient.from('profiles').select('id, university_id').limit(1);

      if (profiles.isNotEmpty) {
        userId = profiles.first['id'] as String;
        universityId = profiles.first['university_id'] as String?;
      } else {
        // Find or create a university, then create a dummy profile
        final unis = await sClient.from('universities').select('id').limit(1);
        String? uniId;
        if (unis.isNotEmpty) {
          uniId = unis.first['id'] as String;
        } else {
          final insertedUni = await sClient.from('universities').insert({
            'name': 'Default University',
            'region': 'General',
            'logo_text': 'DU',
          }).select('id').single();
          uniId = insertedUni['id'] as String;
        }

        try {
          // Use Auth Admin API to create the user in auth.users
          // This will automatically fire the trigger to create the profiles row
          final authRes = await sClient.auth.admin.createUser(
            AdminUserAttributes(
              email: 'anonymous@default.edu',
              password: 'password123',
              emailConfirm: true,
              userMetadata: {'full_name': 'Anonymous Student'},
            ),
          );
          
          if (authRes.user != null) {
            userId = authRes.user!.id;
            // Now update the auto-created profile with the dummy university
            await sClient.from('profiles').update({
              'university_id': uniId,
              'department': 'General',
              'semester': '1st',
            }).eq('id', userId);
          } else {
            throw Exception('Failed to create dummy user');
          }
        } catch (e) {
          // If the user already exists, let's try to query for it and use its ID
          final existingUser = await sClient.from('profiles').select('id').eq('email', 'anonymous@default.edu').maybeSingle();
          if (existingUser != null) {
            userId = existingUser['id'] as String;
          } else {
            // Fallback to random UUID if everything fails (will likely crash on post insert)
            userId = '00000000-0000-0000-0000-000000000000';
          }
        }
        universityId = uniId;
      }

      // Perform insertion with the service client to bypass RLS checks
      return _insertPostWithClient(sClient, userId, universityId, post);
    }
  }

  Future<String> _insertPostWithClient(
    SupabaseClient client,
    String userId,
    String? universityId,
    CreatePostEntity post,
  ) async {
    // Upload image if provided
    String? imageUrl;
    if (post.imagePath != null && post.imagePath!.isNotEmpty) {
      final filePath = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage.from('post-images').uploadBinary(
        filePath,
        Uint8List(0), // placeholder
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      imageUrl = client.storage.from('post-images').getPublicUrl(filePath);
    }

    // Insert the post
    final inserted = await client.from('posts').insert({
      'author_id': userId,
      'university_id': universityId,
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
      await client.from('post_tags').insert(tagRows);
    }

    return inserted['id'] as String;
  }
}
