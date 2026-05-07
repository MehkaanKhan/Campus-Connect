import '../entities/carpool_ride_entity.dart';
import '../repositories/carpool_repository.dart';

class GetCarpoolRidesUsecase {
  final CarpoolRepository _repo;
  const GetCarpoolRidesUsecase(this._repo);

  Future<List<CarpoolRideEntity>> call() => _repo.getRides();
}
