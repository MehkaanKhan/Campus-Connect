import '../entities/onboarding_page_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingPagesUsecase {
  final OnboardingRepository repository;
  const GetOnboardingPagesUsecase(this.repository);

  List<OnboardingPageEntity> call() => repository.getPages();
}
