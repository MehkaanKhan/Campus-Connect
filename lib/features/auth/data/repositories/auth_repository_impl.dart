import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  const AuthRepositoryImpl(this._remote);

  @override
  Future<UserEntity> login({required String email, required String password}) =>
      _remote.login(email: email, password: password);

  @override
  Future<UserEntity> signup({
    required String name,
    required String email,
    required String password,
  }) =>
      _remote.signup(name: name, email: email, password: password);

  @override
  Future<void> logout() => _remote.logout();

  @override
  Future<void> resetPassword({required String email}) =>
      _remote.resetPassword(email: email);

  @override
  Future<UserEntity?> getCurrentUser() async => null;
}
