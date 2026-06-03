import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({required String name, required String email, required String password});
  Future<void> logout();
  Future<void> resetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await SupabaseService.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Login failed');
    return _fromSupabase(user);
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await SupabaseService.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
    final user = response.user;
    if (user == null) throw Exception('Sign up failed');
    return _fromSupabase(user, name: name);
  }

  @override
  Future<void> logout() async {
    await SupabaseService.auth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await SupabaseService.auth.resetPasswordForEmail(
      email,
      redirectTo: 'campusconnect://login-callback/',
    );
  }

  // helper maps Supabase's User object to your internal UserModel
  UserModel _fromSupabase(User user, {String? name}) => UserModel(
        id: user.id,
        name: name ?? user.userMetadata?['full_name'] as String? ?? user.email ?? '',
        email: user.email ?? '',
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
}
