import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/other_uni_entity.dart';

abstract class OtherUnisRemoteDataSource {
  Future<List<OtherUniEntity>> getUniversities();
}

class OtherUnisRemoteDataSourceImpl implements OtherUnisRemoteDataSource {
  final SupabaseClient _client;

  OtherUnisRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<OtherUniEntity>> getUniversities() async {
    final data = await _client
        .from('universities')
        .select('id, name, region, member_count, activity_score, logo_text, description, image_url')
        .order('activity_score', ascending: false);

    return (data as List).map((u) {
      final imageFile = u['image_url'] as String?;
      final imageUrl = (imageFile != null && imageFile.isNotEmpty)
          ? _client.storage.from('university-images').getPublicUrl(imageFile)
          : null;
      return OtherUniEntity(
        id: u['id'] as String,
        name: u['name'] as String,
        region: u['region'] as String? ?? '',
        memberCount: u['member_count'] as int? ?? 0,
        activityScore: u['activity_score'] as int? ?? 0,
        logoText: u['logo_text'] as String? ?? '',
        description: u['description'] as String? ?? '',
        imageUrl: imageUrl,
      );
    }).toList();
  }
}
