import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/carpool_ride_entity.dart';

abstract class CarpoolRemoteDataSource {
  Future<List<CarpoolRideEntity>> getRides();
  Future<void> joinRide(String rideId);
  Future<void> postRide(CarpoolRideEntity ride);
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
    final userId = SupabaseService.uid;
    await _client.from('carpool_passengers').insert({
      'ride_id': rideId,
      'user_id': userId,
    });
    await _incrementTakenSeats(rideId);
    _notifyDriver(rideId, userId).ignore();
  }

  Future<void> _incrementTakenSeats(String rideId) async {
    final data = await _client
        .from('carpool_rides')
        .select('taken_seats')
        .eq('id', rideId)
        .maybeSingle();
    if (data == null) return;
    final current = (data['taken_seats'] as int?) ?? 0;
    await _client
        .from('carpool_rides')
        .update({'taken_seats': current + 1})
        .eq('id', rideId);
  }

  Future<void> _notifyDriver(String rideId, String joinerId) async {
    final ride = await _client
        .from('carpool_rides')
        .select('driver_id, origin, destination')
        .eq('id', rideId)
        .maybeSingle();
    if (ride == null) return;
    final driverId = ride['driver_id'] as String?;
    if (driverId == null || driverId == joinerId) return;

    final joiner = await _client
        .from('profiles')
        .select('full_name, avatar_url')
        .eq('id', joinerId)
        .maybeSingle();
    final joinerName = joiner?['full_name'] as String? ?? 'Someone';
    final joinerAvatar = joiner?['avatar_url'] as String?;
    final origin = ride['origin'] as String? ?? '';
    final destination = ride['destination'] as String? ?? '';

    await _client.from('notifications').insert({
      'user_id': driverId,
      'type': 'carpool',
      'message': '$joinerName joined your ride ($origin → $destination)',
      'is_read': false,
      'has_action': false,
      'avatar_url': joinerAvatar,
    });
  }

  @override
  Future<void> postRide(CarpoolRideEntity ride) async {
    await _client.from('carpool_rides').insert({
      'driver_id': SupabaseService.uid,
      'origin': ride.from,
      'destination': ride.to,
      'departure_time': ride.time,
      'departure_date': ride.date,
      'total_seats': ride.totalSeats,
      'taken_seats': 0,
      'estimated_minutes': ride.estimatedMinutes,
      'filter_slot': _filterStr(ride.filter),
    });
  }

  String _filterStr(CarpoolFilter f) {
    switch (f) {
      case CarpoolFilter.morning: return 'morning';
      case CarpoolFilter.evening: return 'evening';
      case CarpoolFilter.weekend: return 'weekend';
      case CarpoolFilter.all:     return 'morning';
    }
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
