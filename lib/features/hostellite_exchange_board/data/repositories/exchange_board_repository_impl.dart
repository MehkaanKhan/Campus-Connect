import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../../domain/repositories/exchange_board_repository.dart';
import '../datasources/exchange_board_remote_datasource.dart';

class ExchangeBoardRepositoryImpl implements ExchangeBoardRepository {
  final ExchangeBoardRemoteDataSource _remoteSource;

  const ExchangeBoardRepositoryImpl(this._remoteSource);

  @override
  Future<void> submitComplaint({
    required String itemId,
    required String reason,
    required String details,
  }) {
    return _remoteSource.submitComplaint(
      itemId: itemId,
      reason: reason,
      details: details,
    );
  }

  @override
  Future<void> createExchangeItem({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  }) {
    return _remoteSource.createExchangeItem(
      title: title,
      description: description,
      type: type,
      price: price,
      priceUnit: priceUnit,
      condition: condition,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> updateItemAvailability({
    required String itemId,
    required bool isAvailable,
  }) {
    return _remoteSource.updateItemAvailability(
      itemId: itemId,
      isAvailable: isAvailable,
    );
  }

  @override
  Future<void> deleteExchangeItem(String itemId) {
    return _remoteSource.deleteExchangeItem(itemId);
  }

  @override
  Future<List<ExchangeItemEntity>> getMyItems() {
    return _remoteSource.getMyItems();
  }
}
