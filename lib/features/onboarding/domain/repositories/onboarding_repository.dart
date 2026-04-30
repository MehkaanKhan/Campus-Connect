import '../entities/onboarding_page_entity.dart';

abstract class OnboardingRepository {
  List<OnboardingPageEntity> getPages();
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingSeen();
}
