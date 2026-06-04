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

  // Stores the search query and rebuilds; actual filtering happens in the items getter.
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Returns _items filtered client-side by searchQuery (no re-fetch needed).
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

  // Fetches available items from Supabase, applying the active type filter server-side.
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

  // Updates the active type filter then re-fetches from the server immediately.
  Future<void> setFilter(ItemType? type) async {
    _filter = type;
    await load();
  }

  // Inserts a new listing via the use case, then reloads so the list includes the new item.
  // Returns true/false so the bottom sheet can pop on success or show an error inline.
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
