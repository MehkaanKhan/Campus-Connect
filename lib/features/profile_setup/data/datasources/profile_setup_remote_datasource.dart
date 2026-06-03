import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/profile_setup_entity.dart';
import '../models/university_model.dart';

/// Remote operations for profile setup — backed by `profiles` table
/// and `avatars` storage bucket.
abstract class ProfileSetupRemoteDataSource {
  Future<List<UniversityModel>> getUniversities();
  Future<List<String>> getDepartments();
  Future<List<String>> getSemesters();
  Future<void> saveProfile(ProfileSetupEntity profile);
}

class ProfileSetupRemoteDataSourceImpl implements ProfileSetupRemoteDataSource {
  final SupabaseClient _client;

  ProfileSetupRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<UniversityModel>> getUniversities() async {
    final response = await _client
        .from('universities')
        .select()
        .order('name', ascending: true);
    
    return (response as List).map((json) => UniversityModel.fromJson(json)).toList();
  }

  @override
  Future<List<String>> getDepartments() async {
    final response = await _client
        .from('departments')
        .select('name')
        .order('name', ascending: true);
    return (response as List).map((row) => row['name'] as String).toList();
  }

  @override
  Future<List<String>> getSemesters() async {
    final response = await _client
        .from('semesters')
        .select('name')
        .order('sort_order', ascending: true);
    return (response as List).map((row) => row['name'] as String).toList();
  }

  @override
  Future<void> saveProfile(ProfileSetupEntity profile) async {
    final userId = SupabaseService.uid;

    // Upload avatar if photoBytes are provided
    String? avatarUrl;
    if (profile.photoBytes != null && profile.photoBytes!.isNotEmpty) {
      final filePath = '$userId/avatar.jpg';
      
      await SupabaseService.avatarsBucket.uploadBinary(
        filePath,
        profile.photoBytes!,
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
      'university_id': profile.universityId,
      'department': profile.department,
      'semester': profile.semester,
    };
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }

    await _client.from('profiles').update(updates).eq('id', userId);
  }
}
