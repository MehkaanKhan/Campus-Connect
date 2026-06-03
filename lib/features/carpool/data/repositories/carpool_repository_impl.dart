import '../../domain/entities/carpool_ride_entity.dart';
import '../../domain/repositories/carpool_repository.dart';
import '../datasources/carpool_remote_datasource.dart';

class CarpoolRepositoryImpl implements CarpoolRepository {
  final CarpoolRemoteDataSource _source;
  const CarpoolRepositoryImpl(this._source);

  @override
  Future<List<CarpoolRideEntity>> getRides() => _source.getRides();

  @override
  Future<void> joinRide(String rideId) => _source.joinRide(rideId);

  @override
  Future<void> postRide(CarpoolRideEntity ride) => _source.postRide(ride);
}
