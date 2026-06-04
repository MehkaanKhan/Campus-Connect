import 'dart:async';
import 'dart:typed_data';
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

  // Restores an existing session on app start and listens for Supabase auth
  // events (token refresh, remote sign-out, password-recovery deep-link).
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

  // Cancels the auth stream subscription to prevent leaks when the provider is removed.
  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  // Signs in with email + password; navigates to feed on success or shows a friendly error.
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

  // Creates a new account; sets needsEmailVerification if Supabase email confirm is ON.
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

  // Signs out the current user and clears local state immediately (no waiting for stream).
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

  // Sends a password-reset email via Supabase; returns true so the page can navigate on success.
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

  // Updates password for a user who is already logged in (Settings flow).
  Future<bool> changePassword({required String newPassword}) async {
    _setLoading();
    try {
      await SupabaseService.auth.updateUser(UserAttributes(password: newPassword));
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_friendly(e.toString()));
      notifyListeners();
      return false;
    }
  }

  // Updates password from the recovery deep-link then signs out, forcing a fresh login.
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

  // Uploads avatar to Storage (upsert) and updates the profiles table, then re-syncs _user.
  Future<bool> updateProfile({
    required String name,
    Uint8List? photoBytes,
  }) async {
    _setLoading();
    try {
      final uid = SupabaseService.uid;
      String? avatarUrl;

      if (photoBytes != null && photoBytes.isNotEmpty) {
        final filePath = '$uid/avatar.jpg';
        await SupabaseService.avatarsBucket.uploadBinary(
          filePath,
          photoBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );
        avatarUrl = SupabaseService.avatarsBucket.getPublicUrl(filePath);
      }

      final updates = <String, dynamic>{'full_name': name};
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      await SupabaseService.client.from('profiles').update(updates).eq('id', uid);

      await refreshUser();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(_friendly(e.toString()));
      notifyListeners();
      return false;
    }
  }

  // Re-fetches the profiles row and patches _user in memory via copyWith.
  Future<void> refreshUser() async {
    final uid = SupabaseService.uid;
    final data = await SupabaseService.client
        .from('profiles')
        .select('full_name, avatar_url, university_id')
        .eq('id', uid)
        .single();
    if (_user != null) {
      _user = _user!.copyWith(
        name: data['full_name'] as String? ?? _user!.name,
        avatarUrl: data['avatar_url'] as String?,
        universityId: data['university_id'] as String?,
      );
    }
  }

  // Clears the last error so the UI stops showing the error state.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  // Sets loading status and clears any previous error, then notifies so the spinner appears.
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  // Stores the error message without notifying — the caller's notifyListeners() covers it.
  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
  }

  // Maps a Supabase User object to the domain UserEntity.
  UserEntity _entityFrom(User user) => UserEntity(
        id: user.id,
        name: user.userMetadata?['full_name'] as String? ?? user.email ?? '',
        email: user.email ?? '',
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );

  // Converts raw Supabase error strings into user-readable messages.
  String _friendly(String raw) {
    if (raw.contains('Invalid login credentials')) return 'Incorrect email or password';
    if (raw.contains('Email not confirmed')) return 'Please verify your email before signing in';
    if (raw.contains('User already registered')) return 'An account with this email already exists';
    if (raw.contains('Password should be')) return 'Password must be at least 6 characters';
    if (raw.contains('rate limit')) return 'Too many attempts — please wait a moment';
    return raw;
  }
}
