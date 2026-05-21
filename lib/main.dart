import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/utils/size_config.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

import 'features/settings/presentation/provider/settings_provider.dart';

import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'features/cart/presentation/provider/cart_provider.dart';

import 'features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'features/onboarding/data/datasources/onboarding_remote_datasource.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'features/onboarding/domain/usecases/mark_onboarding_seen_usecase.dart';
import 'features/onboarding/presentation/provider/onboarding_provider.dart';

import 'features/profile_setup/data/datasources/profile_setup_local_datasource.dart';
import 'features/profile_setup/data/datasources/profile_setup_remote_datasource.dart';
import 'features/profile_setup/data/repositories/profile_setup_repository_impl.dart';
import 'features/profile_setup/domain/usecases/get_universities_usecase.dart';
import 'features/profile_setup/domain/usecases/get_departments_usecase.dart';
import 'features/profile_setup/domain/usecases/get_semesters_usecase.dart';
import 'features/profile_setup/domain/usecases/save_profile_usecase.dart';
import 'features/profile_setup/presentation/provider/profile_setup_provider.dart';

import 'features/create_post/data/datasources/create_post_remote_datasource.dart';
import 'features/create_post/data/repositories/create_post_repository_impl.dart';
import 'features/create_post/domain/usecases/submit_post_usecase.dart';
import 'features/create_post/presentation/provider/create_post_provider.dart';

import 'features/project_partners/data/datasources/project_partners_remote_datasource.dart';
import 'features/project_partners/data/repositories/project_partners_repository_impl.dart';
import 'features/project_partners/domain/usecases/get_project_partners_usecase.dart';
import 'features/project_partners/domain/usecases/add_project_partner_usecase.dart';
import 'features/project_partners/domain/usecases/apply_to_project_usecase.dart';
import 'features/project_partners/domain/usecases/get_applications_usecase.dart';
import 'features/project_partners/domain/usecases/update_application_status_usecase.dart';
import 'features/project_partners/presentation/provider/project_partners_provider.dart';

import 'features/thread/data/datasources/thread_remote_datasource.dart';
import 'features/thread/data/repositories/thread_repository_impl.dart';
import 'features/thread/domain/usecases/thread_usecases.dart';
import 'features/thread/presentation/provider/thread_provider.dart';

import 'features/feed/data/datasources/feed_remote_datasource.dart';
import 'features/feed/data/repositories/feed_repository_impl.dart';
import 'features/feed/domain/usecases/get_feed_usecase.dart';
import 'features/feed/domain/usecases/vote_on_post_usecase.dart';
import 'features/feed/domain/usecases/get_university_name_usecase.dart';
import 'features/feed/presentation/provider/feed_provider.dart';

import 'features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'features/notifications/domain/usecases/mark_all_read_usecase.dart';
import 'features/notifications/presentation/provider/notifications_provider.dart';

import 'features/user_profile/data/datasources/user_profile_remote_datasource.dart';
import 'features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'features/user_profile/domain/usecases/get_user_profile_usecase.dart';
import 'features/user_profile/presentation/provider/user_profile_provider.dart';

import 'features/hostellite_exchange/data/datasources/hostellite_remote_datasource.dart';
import 'features/hostellite_exchange/data/repositories/hostellite_repository_impl.dart';
import 'features/hostellite_exchange/domain/usecases/get_items_usecase.dart';
import 'features/hostellite_exchange/presentation/provider/hostellite_provider.dart';

import 'features/leaderboard/presentation/provider/leaderboard_provider.dart';
import 'features/hostellite_exchange_board/presentation/provider/exchange_board_provider.dart';
import 'features/uni_graph/presentation/provider/uni_graph_provider.dart';
import 'features/other_unis/presentation/provider/other_unis_provider.dart';

import 'features/carpool/data/datasources/carpool_remote_datasource.dart';
import 'features/carpool/data/repositories/carpool_repository_impl.dart';
import 'features/carpool/domain/usecases/get_carpool_rides_usecase.dart';
import 'features/carpool/domain/usecases/join_carpool_ride_usecase.dart';
import 'features/carpool/presentation/provider/carpool_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRemote  = AuthRemoteDataSourceImpl();
    final authRepo    = AuthRepositoryImpl(authRemote);

    // AuthProvider is created here so it can be shared with the router
    final authProvider = AuthProvider(
      loginUsecase:         LoginUsecase(authRepo),
      signupUsecase:        SignupUsecase(authRepo),
      logoutUsecase:        LogoutUsecase(authRepo),
      resetPasswordUsecase: ResetPasswordUsecase(authRepo),
    );

    final cartRepo    = CartRepositoryImpl();

    // ── Onboarding ──
    final obLocal     = OnboardingLocalDataSourceImpl();
    final obRemote    = OnboardingRemoteDataSourceImpl();
    final obRepo      = OnboardingRepositoryImpl(obLocal, obRemote);

    // ── Profile Setup ──
    final psLocal     = ProfileSetupLocalDataSourceImpl();
    final psRemote    = ProfileSetupRemoteDataSourceImpl();
    final psRepo      = ProfileSetupRepositoryImpl(psLocal, psRemote);

    // ── Create Post ──
    final cpRemote    = CreatePostRemoteDataSourceImpl();
    final cpRepo      = CreatePostRepositoryImpl(cpRemote);

    // ── Project Partners ──
    final ppRemote    = ProjectPartnersRemoteDataSourceImpl();
    final ppRepo      = ProjectPartnersRepositoryImpl(ppRemote);

    // ── Thread ──
    final threadRemote = ThreadRemoteDataSourceImpl();
    final threadRepo   = ThreadRepositoryImpl(threadRemote);

    // ── Feed ──
    final feedRemote   = FeedRemoteDataSourceImpl();
    final feedRepo     = FeedRepositoryImpl(feedRemote);

    // ── Notifications ──
    final notifSource  = NotificationsRemoteDataSourceImpl();
    final notifRepo    = NotificationsRepositoryImpl(notifSource);

    // ── User Profile ──
    final upSource     = UserProfileRemoteDataSourceImpl();
    final upRepo       = UserProfileRepositoryImpl(upSource);

    // ── Hostellite Exchange ──
    final heSource     = HostelliteRemoteDataSourceImpl();
    final heRepo       = HostelliteRepositoryImpl(heSource);

    // ── Carpool ──
    final carpoolSource = CarpoolRemoteDataSourceImpl();
    final carpoolRepo   = CarpoolRepositoryImpl(carpoolSource);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(
            getPagesUsecase: GetOnboardingPagesUsecase(obRepo),
            markSeenUsecase: MarkOnboardingSeenUsecase(obRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileSetupProvider(
            getUniversitiesUsecase: GetUniversitiesUsecase(psRepo),
            getDepartmentsUsecase: GetDepartmentsUsecase(psRepo),
            getSemestersUsecase:   GetSemestersUsecase(psRepo),
            saveProfileUsecase:    SaveProfileUsecase(psRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CreatePostProvider(
            submitPostUsecase: SubmitPostUsecase(cpRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectPartnersProvider(
            getProjectsUsecase:             GetProjectPartnersUsecase(ppRepo),
            getFilterChipsUsecase:          GetFilterChipsUsecase(ppRepo),
            addProjectUseCase:              AddProjectPartnerUseCase(ppRepo),
            applyToProjectUsecase:          ApplyToProjectUsecase(ppRepo),
            getApplicationsUsecase:         GetApplicationsUsecase(ppRepo),
            updateApplicationStatusUsecase: UpdateApplicationStatusUsecase(ppRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ThreadProvider(
            getThreadUsecase:          GetThreadUsecase(threadRepo),
            postCommentUsecase:        PostCommentUsecase(threadRepo),
            toggleAllowRepliesUsecase: ToggleAllowRepliesUsecase(threadRepo),
          ),
        ),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(
            repo:          cartRepo,
            addUsecase:    AddToCartUsecase(cartRepo),
            removeUsecase: RemoveFromCartUsecase(cartRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => FeedProvider(
            getFeedUsecase: GetFeedUsecase(feedRepo),
            voteUsecase:    VoteOnPostUsecase(feedRepo),
            getUniversityNameUsecase: GetUniversityNameUsecase(feedRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsProvider(
            getUsecase:      GetNotificationsUsecase(notifRepo),
            markReadUsecase: MarkAllReadUsecase(notifRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProfileProvider(
            usecase: GetUserProfileUsecase(upRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HostelliteProvider(
            usecase: GetExchangeItemsUsecase(heRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CarpoolProvider(
            getRidesUsecase: GetCarpoolRidesUsecase(carpoolRepo),
            joinRideUsecase: JoinCarpoolRideUsecase(carpoolRepo),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeBoardProvider()),
        ChangeNotifierProvider(create: (_) => UniGraphProvider()),
        ChangeNotifierProvider(create: (_) => OtherUnisProvider()),
      ],
      child: MaterialApp.router(
        title: 'Campus Connect',
        theme: AppTheme.light,
        routerConfig: createRouter(authProvider),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          SizeConfig.init(context);
          return child!;
        },
      ),
    );
  }
}
