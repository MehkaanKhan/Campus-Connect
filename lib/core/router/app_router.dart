import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile_setup/presentation/pages/profile_setup_page.dart';
import '../../features/create_post/presentation/pages/create_post_page.dart';
import '../../features/project_partners/presentation/pages/project_partners_page.dart';
import '../../features/thread/presentation/pages/thread_page.dart';
import '../../features/auth/presentation/pages/login.dart';
import '../../features/auth/presentation/pages/signup.dart';
import '../../features/auth/presentation/pages/reset_password.dart';
import '../../features/auth/presentation/pages/set_new_password_page.dart';
import '../../features/auth/presentation/pages/logout.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/change_profile_page.dart';
import '../../features/settings/presentation/pages/change_password_page.dart';
import '../../features/settings/presentation/pages/language_page.dart';
import '../../features/settings/presentation/pages/notification_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/user_profile/presentation/pages/user_profile_page.dart';
import '../../features/hostellite_exchange/presentation/pages/hostellite_page.dart';
import '../../features/explore/presentation/pages/explore_hub_page.dart';
import 'home_shell.dart';
import 'placeholder_screens.dart';

import '../../features/leaderboard/presentation/pages/leaderboard_page.dart';
import '../../features/hostellite_exchange_board/presentation/pages/item_detail_page.dart';
import '../../features/hostellite_exchange_board/presentation/pages/complaint_form_page.dart';
import '../../features/hostellite_exchange_board/presentation/pages/my_listings_page.dart';
import '../../features/uni_graph/presentation/pages/uni_graph_page.dart';
import '../../features/other_unis/presentation/pages/other_unis_page.dart';
import '../../features/other_unis/presentation/pages/uni_profile_page.dart';
import '../../features/hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../../features/other_unis/domain/entities/other_uni_entity.dart';
import '../../features/carpool/presentation/pages/carpool_feed_page.dart';
import '../../features/feed/presentation/pages/search_page.dart';

// Routes that don't require a signed-in session
const _publicRoutes = {
  '/onboarding',
  '/login',
  '/signup',
  '/reset-password',
  '/set-new-password',
  '/email-verification',
};

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final loc = state.matchedLocation;

      // Password recovery deep link — send to set-new-password regardless of auth state
      if (authProvider.needsPasswordReset && loc != '/set-new-password') {
        return '/set-new-password';
      }

      // Unauthenticated user trying to access a protected route
      if (!isAuth && !_publicRoutes.contains(loc)) return '/login';

      // Authenticated user trying to access login or signup — send to feed
      if (isAuth && (loc == '/login' || loc == '/signup')) return '/feed';

      return null;
    },
    routes: [
      GoRoute(path: '/onboarding',          builder: (ctx, _) => const OnboardingPage()),
      GoRoute(path: '/profile-setup',        builder: (ctx, _) => const ProfileSetupPage()),
      GoRoute(path: '/create-post',          builder: (ctx, _) => const CreatePostPage()),
      GoRoute(path: '/explore',              builder: (ctx, _) => const ExploreHubPage()),
      GoRoute(path: '/project-partners',     builder: (ctx, _) => const ProjectPartnersPage()),
      GoRoute(
        path: '/thread',
        builder: (ctx, state) {
          final postId = state.uri.queryParameters['id'] ?? '';
          return ThreadPage(postId: postId);
        },
      ),
      GoRoute(path: '/feed',                 builder: (ctx, _) => const FeedPage()),
      GoRoute(path: '/carpool',              builder: (ctx, _) => const CarpoolFeedPage()),
      GoRoute(path: '/notifications',        builder: (ctx, _) => const NotificationsPage()),
      GoRoute(path: '/user-profile',         builder: (ctx, _) => const UserProfilePage()),
      GoRoute(path: '/hostellite-exchange',  builder: (ctx, _) => const HostellitePage()),
      GoRoute(
        path: '/email-verification',
        builder: (ctx, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return EmailVerificationPage(email: email);
        },
      ),
      GoRoute(path: '/login',           builder: (ctx, _) => const LoginPage()),
      GoRoute(path: '/signup',          builder: (ctx, _) => const SignupPage()),
      GoRoute(path: '/reset-password',   builder: (ctx, _) => const ResetPasswordPage()),
      GoRoute(path: '/set-new-password', builder: (ctx, _) => const SetNewPasswordPage()),
      GoRoute(path: '/logout',          builder: (ctx, _) => const LogoutPage()),
      GoRoute(path: '/cart',            builder: (ctx, _) => const CartPage()),
      GoRoute(
        path: '/settings',
        builder: (ctx, _) => const SettingsPage(),
        routes: [
          GoRoute(path: 'profile',          builder: (ctx, _) => const ChangeProfilePage()),
          GoRoute(path: 'change-password', builder: (ctx, _) => const ChangePasswordPage()),
          GoRoute(path: 'language',         builder: (ctx, _) => const LanguagePage()),
          GoRoute(path: 'notifications',    builder: (ctx, _) => const NotificationPage()),
        ],
      ),
      ShellRoute(
        builder: (ctx, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home',    redirect: (context, state) => '/feed'),
          GoRoute(path: '/events',  builder: (ctx, _) => const EventsPlaceholder()),
          GoRoute(path: '/clubs',   builder: (ctx, _) => const ClubsPlaceholder()),
          GoRoute(path: '/profile', builder: (ctx, _) => const ProfilePlaceholder()),
        ],
      ),
      GoRoute(path: '/leaderboard', builder: (ctx, _) => const LeaderboardPage()),
      GoRoute(path: '/hostellite-exchange/detail',     builder: (ctx, state) => ItemDetailPage(item: state.extra as ExchangeItemEntity)),
      GoRoute(path: '/hostellite-exchange/complaint',  builder: (ctx, state) => ComplaintFormPage(item: state.extra as ExchangeItemEntity)),
      GoRoute(path: '/hostellite-exchange/my-listings', builder: (ctx, _) => const MyListingsPage()),
      GoRoute(path: '/uni-graph',    builder: (ctx, _) => const UniGraphPage()),
      GoRoute(path: '/other-unis',   builder: (ctx, _) => const OtherUnisPage()),
      GoRoute(path: '/other-unis/profile', builder: (ctx, state) => UniProfilePage(uni: state.extra as OtherUniEntity)),
      GoRoute(path: '/search', builder: (ctx, _) => const SearchPage()),
    ],
  );
}
