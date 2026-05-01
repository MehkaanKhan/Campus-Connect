import '../repositories/onboarding_repository.dart';

class MarkOnboardingSeenUsecase {
  final OnboardingRepository repository;
  const MarkOnboardingSeenUsecase(this.repository);

  Future<void> call() => repository.markOnboardingSeen();
}
