import '../entities/carpool_ride_entity.dart';

abstract class CarpoolRepository {
  Future<List<CarpoolRideEntity>> getRides();
  Future<void> joinRide(String rideId);
}
