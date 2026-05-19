import 'package:supabase_flutter/supabase_flutter.dart';

/// Single access point for Supabase throughout the app.
///
/// Usage:
///   final client = SupabaseService.client;
///   final user   = SupabaseService.currentUser;
class SupabaseService {
  SupabaseService._();

  /// The raw Supabase client – use for all DB / Storage / Realtime calls.
  static SupabaseClient get client => Supabase.instance.client;

  /// Shorthand for the authenticated Supabase Auth client.
  static GoTrueClient get auth => client.auth;

  /// The currently signed-in user, or null if unauthenticated.
  static User? get currentUser => client.auth.currentUser;

  /// The current user's UUID – throws if not authenticated.
  static String get uid {
    final id = currentUser?.id;
    if (id == null) throw Exception('SupabaseService: no authenticated user');
    return id;
  }

  /// Convenience: Supabase Storage client.
  static SupabaseStorageClient get storage => client.storage;

  // ── Named storage buckets ──────────────────────────────────────────────────
  static StorageFileApi get avatarsBucket => storage.from('avatars');
  static StorageFileApi get postImagesBucket => storage.from('post-images');
}
