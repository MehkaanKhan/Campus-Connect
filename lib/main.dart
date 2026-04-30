import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

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
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'features/onboarding/domain/usecases/mark_onboarding_seen_usecase.dart';
import 'features/onboarding/presentation/provider/onboarding_provider.dart';

import 'features/profile_setup/data/datasources/profile_setup_local_datasource.dart';
import 'features/profile_setup/data/repositories/profile_setup_repository_impl.dart';
import 'features/profile_setup/domain/usecases/get_departments_usecase.dart';
import 'features/profile_setup/domain/usecases/get_semesters_usecase.dart';
import 'features/profile_setup/domain/usecases/save_profile_usecase.dart';
import 'features/profile_setup/presentation/provider/profile_setup_provider.dart';

void main() {
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRemote  = AuthRemoteDataSourceImpl();
    final authRepo    = AuthRepositoryImpl(authRemote);
    final cartRepo    = CartRepositoryImpl();
    final obSource    = OnboardingLocalDataSourceImpl();
    final obRepo      = OnboardingRepositoryImpl(obSource);
    final psSource    = ProfileSetupLocalDataSourceImpl();
    final psRepo      = ProfileSetupRepositoryImpl(psSource);

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
            getDepartmentsUsecase: GetDepartmentsUsecase(psRepo),
            getSemestersUsecase:   GetSemestersUsecase(psRepo),
            saveProfileUsecase:    SaveProfileUsecase(psRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUsecase:         LoginUsecase(authRepo),
            signupUsecase:        SignupUsecase(authRepo),
            logoutUsecase:        LogoutUsecase(authRepo),
            resetPasswordUsecase: ResetPasswordUsecase(authRepo),
          ),
        ),
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
      ],
      child: MaterialApp.router(
        title: 'Campus Connect',
        theme: AppTheme.light,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
