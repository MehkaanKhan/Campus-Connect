import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';

/// Remote operations for onboarding status — backed by `profiles.onboarding_seen`.
/// Static page content remains local (in [OnboardingLocalDataSource]).
abstract class OnboardingRemoteDataSource {
  Future<bool> hasSeenOnboarding();
  Future<void> markOnboardingSeen();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final SupabaseClient _client;

  OnboardingRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<bool> hasSeenOnboarding() async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    final data = await _client
        .from('profiles')
        .select('onboarding_seen')
        .eq('id', user.id)
        .maybeSingle();

    return data?['onboarding_seen'] == true;
  }

  @override
  Future<void> markOnboardingSeen() async {
    final user = SupabaseService.currentUser;
    if (user == null) return; // not authenticated yet; flag is set post-signup
    await _client
        .from('profiles')
        .update({'onboarding_seen': true})
        .eq('id', user.id);
  }
}
