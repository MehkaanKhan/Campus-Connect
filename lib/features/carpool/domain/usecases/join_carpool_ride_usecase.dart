import '../repositories/carpool_repository.dart';

class JoinCarpoolRideUsecase {
  final CarpoolRepository _repo;
  const JoinCarpoolRideUsecase(this._repo);

  Future<void> call(String rideId) => _repo.joinRide(rideId);
}
