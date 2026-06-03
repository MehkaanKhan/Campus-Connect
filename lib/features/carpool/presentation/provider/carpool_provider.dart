import 'package:flutter/material.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../../domain/usecases/get_carpool_rides_usecase.dart';
import '../../domain/usecases/join_carpool_ride_usecase.dart';
import '../../domain/usecases/post_carpool_ride_usecase.dart';

enum CarpoolStatus { initial, loading, loaded, error }

class CarpoolProvider extends ChangeNotifier {
  final GetCarpoolRidesUsecase _getRidesUsecase;
  final JoinCarpoolRideUsecase _joinRideUsecase;
  final PostCarpoolRideUsecase _postRideUsecase;

  CarpoolProvider({
    required GetCarpoolRidesUsecase getRidesUsecase,
    required JoinCarpoolRideUsecase joinRideUsecase,
    required PostCarpoolRideUsecase postRideUsecase,
  })  : _getRidesUsecase = getRidesUsecase,
        _joinRideUsecase = joinRideUsecase,
        _postRideUsecase = postRideUsecase;

  CarpoolStatus _status = CarpoolStatus.initial;
  List<CarpoolRideEntity> _all = [];
  CarpoolFilter _filter = CarpoolFilter.all;
  String? _error;
  String _searchQuery = '';

  CarpoolStatus get status => _status;
  CarpoolFilter get filter => _filter;
  String? get error => _error;
  bool get isLoading => _status == CarpoolStatus.loading;

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<CarpoolRideEntity> get filtered {
    var list = _filter == CarpoolFilter.all ? _all : _all.where((r) => r.filter == _filter).toList();
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((r) =>
      r.from.toLowerCase().contains(q) ||
      r.to.toLowerCase().contains(q),
    ).toList();
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
    _all[idx] = _all[idx].copyWith(
      hasJoined: true,
      takenSeats: _all[idx].takenSeats + 1,
    );
    notifyListeners();
  }

  Future<bool> postRide(CarpoolRideEntity ride) async {
    _status = CarpoolStatus.loading;
    _error = null;
    notifyListeners();
    try {
      await _postRideUsecase(ride);
      await load();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = CarpoolStatus.error;
      notifyListeners();
      return false;
    }
  }
}
