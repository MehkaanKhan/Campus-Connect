import 'package:flutter/material.dart';
import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../../domain/usecases/submit_complaint_usecase.dart';
import '../../domain/usecases/create_exchange_item_usecase.dart';
import '../../domain/usecases/update_item_availability_usecase.dart';
import '../../domain/usecases/delete_exchange_item_usecase.dart';
import '../../domain/usecases/get_my_items_usecase.dart';

enum ExchangeBoardStatus { initial, loading, loaded, error }

class ExchangeBoardProvider extends ChangeNotifier {
  final SubmitComplaintUsecase _submitComplaintUsecase;
  final CreateExchangeItemUsecase _createItemUsecase;
  final UpdateItemAvailabilityUsecase _updateItemAvailabilityUsecase;
  final DeleteExchangeItemUsecase _deleteItemUsecase;
  final GetMyItemsUsecase _getMyItemsUsecase;

  ExchangeBoardProvider({
    required SubmitComplaintUsecase submitComplaintUsecase,
    required CreateExchangeItemUsecase createItemUsecase,
    required UpdateItemAvailabilityUsecase updateItemAvailabilityUsecase,
    required DeleteExchangeItemUsecase deleteItemUsecase,
    required GetMyItemsUsecase getMyItemsUsecase,
  })  : _submitComplaintUsecase = submitComplaintUsecase,
        _createItemUsecase = createItemUsecase,
        _updateItemAvailabilityUsecase = updateItemAvailabilityUsecase,
        _deleteItemUsecase = deleteItemUsecase,
        _getMyItemsUsecase = getMyItemsUsecase;

  ExchangeBoardStatus _status = ExchangeBoardStatus.initial;
  List<ExchangeItemEntity> _myItems = [];
  String? _error;
  bool _isSubmitting = false;

  ExchangeBoardStatus get status => _status;
  List<ExchangeItemEntity> get myItems => _myItems;
  String? get error => _error;
  bool get isLoading => _status == ExchangeBoardStatus.loading;
  bool get isSubmitting => _isSubmitting;

  Future<void> loadMyItems() async {
    _status = ExchangeBoardStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _myItems = await _getMyItemsUsecase();
      _status = ExchangeBoardStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = ExchangeBoardStatus.error;
    }
    notifyListeners();
  }

  Future<bool> submitComplaint(String itemId, String reason, String details) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await _submitComplaintUsecase(
        itemId: itemId,
        reason: reason,
        details: details,
      );
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createExchangeItem({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await _createItemUsecase(
        title: title,
        description: description,
        type: type,
        price: price,
        priceUnit: priceUnit,
        condition: condition,
        imageUrl: imageUrl,
      );
      _isSubmitting = false;
      await loadMyItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateItemAvailability(String itemId, bool isAvailable) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await _updateItemAvailabilityUsecase(
        itemId: itemId,
        isAvailable: isAvailable,
      );
      _isSubmitting = false;
      await loadMyItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExchangeItem(String itemId) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      await _deleteItemUsecase(itemId);
      _isSubmitting = false;
      await loadMyItems();
      return true;
    } catch (e) {
      _error = e.toString();
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
