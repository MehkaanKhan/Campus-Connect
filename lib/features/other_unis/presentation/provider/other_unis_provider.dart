import 'package:flutter/material.dart';
import '../../domain/entities/other_uni_entity.dart';

class OtherUnisProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OtherUniEntity> _allUnis = [];
  List<OtherUniEntity> _filteredUnis = [];
  List<OtherUniEntity> get unis => _filteredUnis;

  String _searchQuery = '';

  void loadUnis() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _allUnis = [
      OtherUniEntity(id: '1', name: 'NUST', region: 'Islamabad', memberCount: 5400, activityScore: 92, logoText: 'N', description: 'National University of Sciences & Technology'),
      OtherUniEntity(id: '2', name: 'FAST-NUCES', region: 'Lahore', memberCount: 3200, activityScore: 88, logoText: 'F', description: 'Foundation for Advancement of Science and Technology'),
      OtherUniEntity(id: '3', name: 'LUMS', region: 'Lahore', memberCount: 2800, activityScore: 85, logoText: 'L', description: 'Lahore University of Management Sciences'),
      OtherUniEntity(id: '4', name: 'GIKI', region: 'Topi', memberCount: 1500, activityScore: 78, logoText: 'G', description: 'Ghulam Ishaq Khan Institute'),
      OtherUniEntity(id: '5', name: 'IBA', region: 'Karachi', memberCount: 2100, activityScore: 80, logoText: 'I', description: 'Institute of Business Administration'),
      OtherUniEntity(id: '6', name: 'UET', region: 'Lahore', memberCount: 4500, activityScore: 70, logoText: 'U', description: 'University of Engineering and Technology'),
      OtherUniEntity(id: '7', name: 'COMSATS', region: 'Islamabad', memberCount: 6200, activityScore: 82, logoText: 'C', description: 'COMSATS Institute of Information Technology'),
      OtherUniEntity(id: '8', name: 'PU', region: 'Lahore', memberCount: 12000, activityScore: 65, logoText: 'P', description: 'Punjab University'),
    ];
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
