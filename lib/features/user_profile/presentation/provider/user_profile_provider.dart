import 'package:flutter/material.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';

class UserProfileProvider extends ChangeNotifier {
  final GetUserProfileUsecase _usecase;

  UserProfileProvider({required GetUserProfileUsecase usecase}) : _usecase = usecase;

  UserProfileEntity? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _usecase(userId);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
