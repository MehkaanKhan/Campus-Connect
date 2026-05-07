import '../../domain/entities/carpool_ride_entity.dart';

abstract class CarpoolLocalDataSource {
  Future<List<CarpoolRideEntity>> getRides();
}

class CarpoolLocalDataSourceImpl implements CarpoolLocalDataSource {
  @override
  Future<List<CarpoolRideEntity>> getRides() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      CarpoolRideEntity(
        id: 'c1',
        from: 'Downtown',
        to: 'Campus',
        time: '9:00 AM',
        date: 'Today',
        totalSeats: 4,
        takenSeats: 1,
        driverName: 'Ahmed R.',
        estimatedMinutes: 15,
        filter: CarpoolFilter.morning,
      ),
      CarpoolRideEntity(
        id: 'c2',
        from: 'Campus',
        to: 'Airport',
        time: '5:00 PM',
        date: 'Tomorrow',
        totalSeats: 3,
        takenSeats: 2,
        driverName: 'Sara K.',
        estimatedMinutes: 40,
        filter: CarpoolFilter.evening,
      ),
      CarpoolRideEntity(
        id: 'c3',
        from: 'Campus',
        to: 'City Center',
        time: '7:30 AM',
        date: 'Today',
        totalSeats: 4,
        takenSeats: 0,
        driverName: 'Omar J.',
        estimatedMinutes: 22,
        filter: CarpoolFilter.morning,
      ),
      CarpoolRideEntity(
        id: 'c4',
        from: 'Shopping Mall',
        to: 'Campus',
        time: '6:00 PM',
        date: 'Today',
        totalSeats: 3,
        takenSeats: 1,
        driverName: 'Layla M.',
        estimatedMinutes: 18,
        filter: CarpoolFilter.evening,
      ),
      CarpoolRideEntity(
        id: 'c5',
        from: 'Campus',
        to: 'Old Town',
        time: '10:00 AM',
        date: 'Saturday',
        totalSeats: 4,
        takenSeats: 2,
        driverName: 'Zain A.',
        estimatedMinutes: 30,
        filter: CarpoolFilter.weekend,
      ),
    ];
  }
}
