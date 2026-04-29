import '../repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _repo;
  const ResetPasswordUsecase(this._repo);

  Future<void> call({required String email}) =>
      _repo.resetPassword(email: email);
}
