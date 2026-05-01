import '../../domain/entities/onboarding_page_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localSource;

  const OnboardingRepositoryImpl(this.localSource);

  @override
  List<OnboardingPageEntity> getPages() => localSource.getStaticPages();

  @override
  Future<bool> hasSeenOnboarding() => localSource.hasSeenOnboarding();

  @override
  Future<void> markOnboardingSeen() => localSource.markOnboardingSeen();
}
