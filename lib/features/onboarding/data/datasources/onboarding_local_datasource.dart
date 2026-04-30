import '../models/onboarding_page_model.dart';


abstract class OnboardingLocalDataSource {
  List<OnboardingPageModel> getStaticPages();
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingSeen();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  List<OnboardingPageModel> getStaticPages() => const [
        OnboardingPageModel(
          title: 'Your Campus,\nConnected.',
          subtitle:
              'The exclusive hub for your university life. Community, marketplace, and more.',
          imagePath: 'assets/images/onboarding_hero.png',
        ),
        OnboardingPageModel(
          title: 'Meet Your\nPeople.',
          subtitle:
              'Connect with classmates, find project partners, and join campus communities.',
          imagePath: 'assets/images/onboarding_hero.png',
        ),
        OnboardingPageModel(
          title: 'Campus Life,\nSimplified.',
          subtitle:
              'From carpooling to hostelite exchanges — everything you need in one place.',
          imagePath: 'assets/images/onboarding_hero.png',
        ),
      ];

  @override
  Future<bool> hasSeenOnboarding() async => false; // replace with SharedPreferences

  @override
  Future<void> markOnboardingSeen() async {} // replace with SharedPreferences
}
