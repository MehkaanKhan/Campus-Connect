import 'package:flutter/material.dart';
import '../../domain/entities/exchange_item_entity.dart';
import '../../domain/usecases/get_items_usecase.dart';

class HostelliteProvider extends ChangeNotifier {
  final GetExchangeItemsUsecase _usecase;

  HostelliteProvider({required GetExchangeItemsUsecase usecase}) : _usecase = usecase;

  List<ExchangeItemEntity> _items = [];
  ItemType? _filter; // null = All
  bool _isLoading = false;

  List<ExchangeItemEntity> get items => _items;
  ItemType? get filter => _filter;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _items = await _usecase(filter: _filter);  // when no filter -> all, when filter -> speicifc data
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setFilter(ItemType? type) async {
    _filter = type;
    await load(); // to re-fetch from repo with new filter -> passes down -> usecases return right items
  }
}
