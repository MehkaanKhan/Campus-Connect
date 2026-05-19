import '../../domain/entities/onboarding_page_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';
import '../datasources/onboarding_remote_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localSource;
  final OnboardingRemoteDataSource remoteSource;

  const OnboardingRepositoryImpl(this.localSource, this.remoteSource);

  @override
  List<OnboardingPageEntity> getPages() => localSource.getStaticPages();

  @override
  Future<bool> hasSeenOnboarding() => remoteSource.hasSeenOnboarding();

  @override
  Future<void> markOnboardingSeen() => remoteSource.markOnboardingSeen();
}
