import 'package:flutter/material.dart';
import '../../domain/entities/exchange_item_entity.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../domain/usecases/list_item_usecase.dart';

enum HostelliteStatus { initial, loading, loaded, error }

class HostelliteProvider extends ChangeNotifier {
  final GetExchangeItemsUsecase _usecase;
  final ListItemUsecase _listItemUsecase;

  HostelliteProvider({
    required GetExchangeItemsUsecase usecase,
    required ListItemUsecase listItemUsecase,
  })  : _usecase = usecase,
        _listItemUsecase = listItemUsecase;

  List<ExchangeItemEntity> _items = [];
  ItemType? _filter;
  HostelliteStatus _status = HostelliteStatus.initial;
  String? _error;
  String _searchQuery = '';

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<ExchangeItemEntity> get items {
    if (_searchQuery.isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((i) =>
      i.title.toLowerCase().contains(q) ||
      i.description.toLowerCase().contains(q),
    ).toList();
  }
  ItemType? get filter => _filter;
  HostelliteStatus get status => _status;
  bool get isLoading => _status == HostelliteStatus.loading;
  String? get error => _error;

  Future<void> load() async {
    _status = HostelliteStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _items = await _usecase(filter: _filter);
      _status = HostelliteStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = HostelliteStatus.error;
    }
    notifyListeners();
  }

  Future<void> setFilter(ItemType? type) async {
    _filter = type;
    await load();
  }

  Future<bool> listItem(ExchangeItemEntity item, {List<int>? imageBytes}) async {
    _status = HostelliteStatus.loading;
    _error = null;
    notifyListeners();
    try {
      await _listItemUsecase(item, imageBytes: imageBytes);
      await load();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = HostelliteStatus.error;
      notifyListeners();
      return false;
    }
  }
}
