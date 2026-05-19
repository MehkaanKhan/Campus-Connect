import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/onboarding_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_continue_button.dart';
import '../widgets/onboarding_terms_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onContinue(BuildContext context, OnboardingProvider provider) async {
    if (provider.isLastPage) {
      try {
        await provider.completeOnboarding();
      } catch (_) {}
      if (context.mounted) context.go('/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: provider.pages.length,
                onPageChanged: provider.goToPage,
                itemBuilder: (context, index) {
                  final page = provider.pages[index];
                  return OnboardingSlide(
                    title: page.title,
                    subtitle: page.subtitle,
                    imagePath: page.imagePath,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 28.h),
              child: OnboardingPageIndicator(
                count: provider.pages.length,
                current: provider.currentIndex,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: OnboardingContinueButton(
                isLast: provider.isLastPage,
                onTap: () => _onContinue(context, provider),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 14.h,
                bottom: 24.h,
                left: 24.w,
                right: 24.w,
              ),
              child: const OnboardingTermsText(),
            ),
          ],
        ),
      ),
    );
  }
}
