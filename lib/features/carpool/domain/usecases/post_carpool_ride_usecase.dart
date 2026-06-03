import '../entities/carpool_ride_entity.dart';
import '../repositories/carpool_repository.dart';

class PostCarpoolRideUsecase {
  final CarpoolRepository _repo;
  PostCarpoolRideUsecase(this._repo);

  Future<void> call(CarpoolRideEntity ride) => _repo.postRide(ride);
}
