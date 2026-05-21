import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';

abstract class ExchangeBoardRepository {
  Future<void> submitComplaint({
    required String itemId,
    required String reason,
    required String details,
  });

  Future<void> createExchangeItem({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  });

  Future<void> updateItemAvailability({
    required String itemId,
    required bool isAvailable,
  });

  Future<void> deleteExchangeItem(String itemId);

  Future<List<ExchangeItemEntity>> getMyItems();
}
