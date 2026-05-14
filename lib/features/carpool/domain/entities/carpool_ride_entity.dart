/// Domain entity – pure Dart, no Flutter/external dependencies.
class CarpoolRideEntity {
  final String id;
  final String from;
  final String to;
  final String time;
  final String date; // e.g. "Today" | "Tomorrow"
  final int totalSeats;
  final int takenSeats;
  final String driverName;
  final String? driverAvatarUrl;
  final String? mapImageUrl; // optional static map preview
  final int estimatedMinutes;
  final bool hasJoined;
  final CarpoolFilter filter; // which time-slot bucket this belongs to

  const CarpoolRideEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.time,
    required this.date,
    required this.totalSeats,
    required this.takenSeats,
    required this.driverName,
    this.driverAvatarUrl,
    this.mapImageUrl,
    required this.estimatedMinutes,
    this.hasJoined = false,
    required this.filter,
  });

  int get seatsAvailable => totalSeats - takenSeats;

  CarpoolRideEntity copyWith({bool? hasJoined}) => CarpoolRideEntity(
        id: id,
        from: from,
        to: to,
        time: time,
        date: date,
        totalSeats: totalSeats,
        takenSeats: takenSeats,
        driverName: driverName,
        driverAvatarUrl: driverAvatarUrl,
        mapImageUrl: mapImageUrl,
        estimatedMinutes: estimatedMinutes,
        hasJoined: hasJoined ?? this.hasJoined,
        filter: filter,
      );
}

enum CarpoolFilter { all, morning, evening, weekend }
