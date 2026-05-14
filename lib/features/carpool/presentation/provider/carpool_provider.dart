import 'package:flutter/material.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../../domain/usecases/get_carpool_rides_usecase.dart';
import '../../domain/usecases/join_carpool_ride_usecase.dart';

enum CarpoolStatus { initial, loading, loaded, error }

class CarpoolProvider extends ChangeNotifier {
  final GetCarpoolRidesUsecase _getRidesUsecase;
  final JoinCarpoolRideUsecase _joinRideUsecase;

  CarpoolProvider({
    required GetCarpoolRidesUsecase getRidesUsecase,
    required JoinCarpoolRideUsecase joinRideUsecase,
  })  : _getRidesUsecase = getRidesUsecase,
        _joinRideUsecase = joinRideUsecase;

  CarpoolStatus _status = CarpoolStatus.initial;
  List<CarpoolRideEntity> _all = [];
  CarpoolFilter _filter = CarpoolFilter.all;
  String? _error;

  CarpoolStatus get status => _status;
  CarpoolFilter get filter => _filter;
  String? get error => _error;
  bool get isLoading => _status == CarpoolStatus.loading;

  List<CarpoolRideEntity> get filtered {
    if (_filter == CarpoolFilter.all) return _all;
    return _all.where((r) => r.filter == _filter).toList();
  }

  Future<void> load() async {
    _status = CarpoolStatus.loading;
    notifyListeners();
    try {
      _all = await _getRidesUsecase();
      _status = CarpoolStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = CarpoolStatus.error;
    }
    notifyListeners();
  }

  void setFilter(CarpoolFilter f) {
    _filter = f;
    notifyListeners();
  }

  Future<void> joinRide(String rideId) async {
    final idx = _all.indexWhere((r) => r.id == rideId);
    if (idx < 0) return;
    await _joinRideUsecase(rideId);
    _all[idx] = _all[idx].copyWith(hasJoined: true);
    notifyListeners();
  }
}
