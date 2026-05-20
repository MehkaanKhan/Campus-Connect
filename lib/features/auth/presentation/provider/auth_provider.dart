import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
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

  StreamSubscription<AuthState>? _authSub;

  AuthProvider({
    required LoginUsecase loginUsecase,
    required SignupUsecase signupUsecase,
    required LogoutUsecase logoutUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
  })  : _loginUsecase = loginUsecase,
        _signupUsecase = signupUsecase,
        _logoutUsecase = logoutUsecase,
        _resetPasswordUsecase = resetPasswordUsecase {
    _init();
  }

  AuthStatus _status = AuthStatus.unauthenticated;
  UserEntity? _user;
  String? _errorMessage;
  bool _needsEmailVerification = false;
  bool _needsPasswordReset = false;

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get needsEmailVerification => _needsEmailVerification;
  bool get needsPasswordReset => _needsPasswordReset;

  void _init() {
    // Restore existing session immediately (covers app restarts)
    final current = SupabaseService.currentUser;
    if (current != null) {
      _status = AuthStatus.authenticated;
      _user = _entityFrom(current);
    }

    // Keep in sync with Supabase token refreshes / remote sign-outs
    _authSub = SupabaseService.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _needsPasswordReset = true;
        notifyListeners();
        return;
      }
      final session = data.session;
      if (session != null) {
        _status = AuthStatus.authenticated;
        _user = _entityFrom(session.user);
      } else {
        _status = AuthStatus.unauthenticated;
        _user = null;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading();
    try {
      _user = await _loginUsecase(email: email, password: password);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _setError(_friendly(e.toString()));
    }
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    _needsEmailVerification = false;
    try {
      _user = await _signupUsecase(name: name, email: email, password: password);
      // If Supabase email confirmation is enabled there will be no session yet
      if (SupabaseService.auth.currentSession != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _needsEmailVerification = true;
      }
    } catch (e) {
      _setError(_friendly(e.toString()));
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
      _setError(_friendly(e.toString()));
      return false;
    }
  }

  Future<bool> setNewPassword({required String password}) async {
    _setLoading();
    try {
      await SupabaseService.auth.updateUser(UserAttributes(password: password));
      await SupabaseService.auth.signOut();
      _needsPasswordReset = false;
      _status = AuthStatus.unauthenticated;
      _user = null;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_friendly(e.toString()));
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
  }

  UserEntity _entityFrom(User user) => UserEntity(
        id: user.id,
        name: user.userMetadata?['full_name'] as String? ?? user.email ?? '',
        email: user.email ?? '',
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );

  String _friendly(String raw) {
    if (raw.contains('Invalid login credentials')) return 'Incorrect email or password';
    if (raw.contains('Email not confirmed')) return 'Please verify your email before signing in';
    if (raw.contains('User already registered')) return 'An account with this email already exists';
    if (raw.contains('Password should be')) return 'Password must be at least 6 characters';
    if (raw.contains('rate limit')) return 'Too many attempts — please wait a moment';
    return raw;
  }
}
