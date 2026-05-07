import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/onboarding_provider.dart';
import '../../../../core/constants/app_theme.dart';

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
      await provider.completeOnboarding();
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
            // ── Slides ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: provider.pages.length,
                onPageChanged: provider.goToPage,
                itemBuilder: (context, index) {
                  final page = provider.pages[index];
                  return _OnboardingSlide(
                    title: page.title,
                    subtitle: page.subtitle,
                    imagePath: page.imagePath,
                  );
                },
              ),
            ),

            // ── Page indicator ──
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: _PageIndicator(
                count: provider.pages.length,
                current: provider.currentIndex,
              ),
            ),

            // ── CTA button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ContinueButton(
                isLast: provider.isLastPage,
                onTap: () => _onContinue(context, provider),
              ),
            ),

            // ── Terms ──
            Padding(
              padding: const EdgeInsets.only(
                top: 14,
                bottom: 24,
                left: 24,
                right: 24,
              ),
              child: const _TermsText(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Slide widget
// ─────────────────────────────────────────────────────────
class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),

          // ── Hero image card ──
          Expanded(
            flex: 6,
            child: _HeroImageCard(imagePath: imagePath),
          ),

          const SizedBox(height: 28),

          // ── Title ──
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          // ── Subtitle ──
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.55,
              color: AppColors.textCaption,
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Hero image card with floating overlay chips
// ─────────────────────────────────────────────────────────
class _HeroImageCard extends StatelessWidget {
  final String imagePath;
  const _HeroImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        );
      },
    );
  }
}



// ─────────────────────────────────────────────────────────
//  Animated page indicator
// ─────────────────────────────────────────────────────────
class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isActive
                ? AppColors.primary
                : AppColors.disabled,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  CTA button
// ─────────────────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onTap;

  const _ContinueButton({required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isLast
                ? 'Get Started  →'
                : 'Continue with University Email  →',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Terms & Privacy footer
// ─────────────────────────────────────────────────────────
class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textLabel,
          height: 1.6,
        ),
        children: [
          TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms',
            style: TextStyle(
              color: Color(0xFF444444),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF444444),
            ),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy\nPolicy',
            style: TextStyle(
              color: AppColors.textPrimary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textPrimary,
            ),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}
