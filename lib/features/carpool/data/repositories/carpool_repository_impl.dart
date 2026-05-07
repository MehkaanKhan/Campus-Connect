import '../../domain/entities/carpool_ride_entity.dart';
import '../../domain/repositories/carpool_repository.dart';
import '../datasources/carpool_local_datasource.dart';

class CarpoolRepositoryImpl implements CarpoolRepository {
  final CarpoolLocalDataSource _source;
  const CarpoolRepositoryImpl(this._source);

  @override
  Future<List<CarpoolRideEntity>> getRides() => _source.getRides();

  @override
  Future<void> joinRide(String rideId) async {
    // In a real app this would call an API.
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
