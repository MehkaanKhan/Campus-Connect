import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../repositories/exchange_board_repository.dart';

class CreateExchangeItemUsecase {
  final ExchangeBoardRepository _repo;

  const CreateExchangeItemUsecase(this._repo);

  Future<void> call({
    required String title,
    required String description,
    required ItemType type,
    double? price,
    String? priceUnit,
    required ItemCondition condition,
    String? imageUrl,
  }) {
    return _repo.createExchangeItem(
      title: title,
      description: description,
      type: type,
      price: price,
      priceUnit: priceUnit,
      condition: condition,
      imageUrl: imageUrl,
    );
  }
}
