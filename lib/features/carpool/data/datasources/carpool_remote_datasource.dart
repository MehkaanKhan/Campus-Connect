import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/carpool_ride_entity.dart';

abstract class CarpoolRemoteDataSource {
  Future<List<CarpoolRideEntity>> getRides();
  Future<void> joinRide(String rideId);
}

class CarpoolRemoteDataSourceImpl implements CarpoolRemoteDataSource {
  final SupabaseClient _client;

  CarpoolRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<List<CarpoolRideEntity>> getRides() async {
    final userId = SupabaseService.uid;

    final ridesData = await _client
        .from('carpool_rides')
        .select(
          'id, origin, destination, departure_time, departure_date, total_seats, taken_seats, estimated_minutes, filter_slot, map_image_url, profiles(full_name, avatar_url)',
        )
        .order('created_at', ascending: false);

    final joinedData = await _client
        .from('carpool_passengers')
        .select('ride_id')
        .eq('user_id', userId);

    final joinedIds = (joinedData as List)
        .map((r) => r['ride_id'] as String)
        .toSet();

    return (ridesData as List).map((r) {
      final profile = r['profiles'] as Map?;
      return CarpoolRideEntity(
        id: r['id'] as String,
        from: r['origin'] as String,
        to: r['destination'] as String,
        time: r['departure_time'] as String,
        date: r['departure_date'] as String? ?? 'Today',
        totalSeats: r['total_seats'] as int,
        takenSeats: r['taken_seats'] as int,
        driverName: profile?['full_name'] as String? ?? 'Unknown',
        driverAvatarUrl: profile?['avatar_url'] as String?,
        mapImageUrl: r['map_image_url'] as String?,
        estimatedMinutes: r['estimated_minutes'] as int? ?? 0,
        hasJoined: joinedIds.contains(r['id'] as String),
        filter: _parseFilter(r['filter_slot'] as String?),
      );
    }).toList();
  }

  @override
  Future<void> joinRide(String rideId) async {
    await _client.from('carpool_passengers').insert({
      'ride_id': rideId,
      'user_id': SupabaseService.uid,
    });
  }

  CarpoolFilter _parseFilter(String? s) {
    switch (s) {
      case 'morning': return CarpoolFilter.morning;
      case 'evening': return CarpoolFilter.evening;
      case 'weekend': return CarpoolFilter.weekend;
      default:        return CarpoolFilter.all;
    }
  }
}
