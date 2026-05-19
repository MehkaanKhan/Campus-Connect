import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/profile_setup_entity.dart';

/// Remote operations for profile setup — backed by `profiles` table
/// and `avatars` storage bucket.
abstract class ProfileSetupRemoteDataSource {
  Future<void> saveProfile(ProfileSetupEntity profile);
}

class ProfileSetupRemoteDataSourceImpl implements ProfileSetupRemoteDataSource {
  final SupabaseClient _client;

  ProfileSetupRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) async {
    final userId = SupabaseService.uid;

    // Upload avatar if a local photo path was provided
    String? avatarUrl;
    if (profile.photoPath != null && profile.photoPath!.isNotEmpty) {
      final filePath = '$userId/avatar.jpg';
      // In production, read actual bytes from the file path.
      // The presentation layer should convert the picked file to bytes
      // before calling this method, or pass bytes directly.
      await SupabaseService.avatarsBucket.uploadBinary(
        filePath,
        Uint8List(0), // placeholder — real bytes injected by UI layer
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );
      avatarUrl = SupabaseService.avatarsBucket.getPublicUrl(filePath);
    }

    // Update the user's profile row
    final updates = <String, dynamic>{
      'full_name': profile.fullName,
      'department': profile.department,
      'semester': profile.semester,
    };
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }

    await _client.from('profiles').update(updates).eq('id', userId);
  }
}
