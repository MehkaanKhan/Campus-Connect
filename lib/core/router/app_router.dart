import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile_setup/presentation/pages/profile_setup_page.dart';
import '../../features/create_post/presentation/pages/create_post_page.dart';
import '../../features/project_partners/presentation/pages/project_partners_page.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/signup.dart';
import '../../features/auth/presentation/pages/reset_password.dart';
import '../../features/auth/presentation/pages/logout.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/change_profile_page.dart';
import '../../features/settings/presentation/pages/language_page.dart';
import '../../features/settings/presentation/pages/notification_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import 'home_shell.dart';
import 'placeholder_screens.dart';

final appRouter = GoRouter(
  initialLocation: '/create-post',
  routes: [
    GoRoute(path: '/onboarding',         builder: (ctx, _) => const OnboardingPage()),
    GoRoute(path: '/profile-setup',       builder: (ctx, _) => const ProfileSetupPage()),
    GoRoute(path: '/create-post',         builder: (ctx, _) => const CreatePostPage()),
    GoRoute(path: '/project-partners',    builder: (ctx, _) => const ProjectPartnersPage()),
    GoRoute(path: '/login',          builder: (ctx, _) => const LoginPage()),
    GoRoute(path: '/signup',         builder: (ctx, _) => const SignupPage()),
    GoRoute(path: '/reset-password', builder: (ctx, _) => const ResetPasswordPage()),
    GoRoute(path: '/logout',         builder: (ctx, _) => const LogoutPage()),
    GoRoute(path: '/cart',           builder: (ctx, _) => const CartPage()),
    GoRoute(
      path: '/settings',
      builder: (ctx, _) => const SettingsPage(),
      routes: [
        GoRoute(path: 'profile',       builder: (ctx, _) => const ChangeProfilePage()),
        GoRoute(path: 'language',      builder: (ctx, _) => const LanguagePage()),
        GoRoute(path: 'notifications', builder: (ctx, _) => const NotificationPage()),
      ],
    ),
    ShellRoute(
      builder: (ctx, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(path: '/home',    builder: (ctx, _) => const HomePlaceholder()),
        GoRoute(path: '/events',  builder: (ctx, _) => const EventsPlaceholder()),
        GoRoute(path: '/clubs',   builder: (ctx, _) => const ClubsPlaceholder()),
        GoRoute(path: '/profile', builder: (ctx, _) => const ProfilePlaceholder()),
      ],
    ),
  ],
);
