import '../repositories/profile_setup_repository.dart';

class GetDepartmentsUsecase {
  final ProfileSetupRepository repository;
  const GetDepartmentsUsecase(this.repository);

  List<String> call() => repository.getDepartments();
}
