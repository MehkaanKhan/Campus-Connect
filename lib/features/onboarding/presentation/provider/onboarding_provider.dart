import 'package:flutter/foundation.dart';
import '../../domain/entities/onboarding_page_entity.dart';
import '../../domain/usecases/get_onboarding_pages_usecase.dart';
import '../../domain/usecases/mark_onboarding_seen_usecase.dart';

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingPagesUsecase getPagesUsecase;
  final MarkOnboardingSeenUsecase markSeenUsecase;

  late final List<OnboardingPageEntity> pages;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  bool get isLastPage => _currentIndex == pages.length - 1;

  OnboardingProvider({
    required this.getPagesUsecase,
    required this.markSeenUsecase,
  }) {
    pages = getPagesUsecase();
  }

  void goToPage(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    if (!isLastPage) {
      _currentIndex++;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    await markSeenUsecase();
  }
}
