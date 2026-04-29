import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final LogoutUsecase _logoutUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;

  AuthProvider({
    required LoginUsecase loginUsecase,
    required SignupUsecase signupUsecase,
    required LogoutUsecase logoutUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
  })  : _loginUsecase = loginUsecase,
        _signupUsecase = signupUsecase,
        _logoutUsecase = logoutUsecase,
        _resetPasswordUsecase = resetPasswordUsecase;

  AuthStatus _status = AuthStatus.unauthenticated;
  UserEntity? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> login({required String email, required String password}) async {
    _setLoading();
    try {
      _user = await _loginUsecase(email: email, password: password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _setError(e.toString());
    }
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      _user = await _signupUsecase(name: name, email: email, password: password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _setError(e.toString());
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading();
    try {
      await _logoutUsecase();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _setError(e.toString());
    }
    notifyListeners();
  }

  Future<bool> resetPassword({required String email}) async {
    _setLoading();
    try {
      await _resetPasswordUsecase(email: email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
  }
}
