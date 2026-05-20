import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/other_uni_entity.dart';

class OtherUnisProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OtherUniEntity> _allUnis = [];
  List<OtherUniEntity> _filteredUnis = [];
  List<OtherUniEntity> get unis => _filteredUnis;

  String _searchQuery = '';

  Future<void> loadUnis() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('universities')
          .select('id, name, region, member_count, activity_score, logo_text, description')
          .order('activity_score', ascending: false);

      _allUnis = (data as List).map((u) => OtherUniEntity(
        id: u['id'] as String,
        name: u['name'] as String,
        region: u['region'] as String? ?? '',
        memberCount: u['member_count'] as int? ?? 0,
        activityScore: u['activity_score'] as int? ?? 0,
        logoText: u['logo_text'] as String? ?? '',
        description: u['description'] as String? ?? '',
      )).toList();
    } on PostgrestException catch (e) {
      debugPrint('OtherUnis error: ${e.message}');
      _allUnis = [];
    } catch (e) {
      debugPrint('OtherUnis error: $e');
      _allUnis = [];
    }

    _filteredUnis = _allUnis;
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
