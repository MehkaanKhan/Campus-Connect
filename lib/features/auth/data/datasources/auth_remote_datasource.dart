import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({required String name, required String email, required String password});
  Future<void> logout();
  Future<void> resetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // inject http client here when connecting to a real API

  @override
  Future<UserModel> login({required String email, required String password}) async {
    // TODO: replace with real API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: '1', name: 'Demo User', email: email);
  }

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: '2', name: name, email: email);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
