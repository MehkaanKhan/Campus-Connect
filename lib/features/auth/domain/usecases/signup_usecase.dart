import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository _repo;
  const SignupUsecase(this._repo);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repo.signup(name: name, email: email, password: password);
}
