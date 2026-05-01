import '../repositories/profile_setup_repository.dart';

class GetSemestersUsecase {
  final ProfileSetupRepository repository;
  const GetSemestersUsecase(this.repository);

  List<String> call() => repository.getSemesters();
}
