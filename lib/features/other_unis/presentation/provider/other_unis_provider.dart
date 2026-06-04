import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/other_uni_entity.dart';

class OtherUnisProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<OtherUniEntity> _allUnis = [];
  List<OtherUniEntity> _filteredUnis = [];
  List<OtherUniEntity> get unis => _filteredUnis;

  String _searchQuery = '';

  Future<void> loadUnis() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('universities')
          .select('id, name, region, member_count, activity_score, logo_text, description, image_url')
          .order('activity_score', ascending: false);

      _allUnis = (data as List).map((u) {
        final imageFile = u['image_url'] as String?;
        final imageUrl = (imageFile != null && imageFile.isNotEmpty)
            ? SupabaseService.client.storage
                .from('university-images')
                .getPublicUrl(imageFile)
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

      _filteredUnis = _allUnis;
    } on PostgrestException catch (e) {
      debugPrint('OtherUnis Postgrest error: ${e.message}');
      _error = e.message;
      _allUnis = [];
      _filteredUnis = [];
    } catch (e) {
      debugPrint('OtherUnis error: $e');
      _error = e.toString();
      _allUnis = [];
      _filteredUnis = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredUnis = _allUnis;
    } else {
      _filteredUnis = _allUnis.where((u) {
        return u.name.toLowerCase().contains(_searchQuery) ||
               u.region.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
