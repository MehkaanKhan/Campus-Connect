import '../../../hostellite_exchange/domain/entities/exchange_item_entity.dart';
import '../repositories/exchange_board_repository.dart';

class GetMyItemsUsecase {
  final ExchangeBoardRepository _repo;

  const GetMyItemsUsecase(this._repo);

  Future<List<ExchangeItemEntity>> call() {
    return _repo.getMyItems();
  }
}
