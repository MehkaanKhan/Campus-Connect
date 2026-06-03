import '../entities/exchange_item_entity.dart';

abstract class HostelliteRepository {
  Future<List<ExchangeItemEntity>> getItems({ItemType? filter});
  Future<void> listItem(ExchangeItemEntity item, {List<int>? imageBytes});
}
