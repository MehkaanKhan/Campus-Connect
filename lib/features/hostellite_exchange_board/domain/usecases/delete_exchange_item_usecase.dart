import '../repositories/exchange_board_repository.dart';

class DeleteExchangeItemUsecase {
  final ExchangeBoardRepository _repo;

  const DeleteExchangeItemUsecase(this._repo);

  Future<void> call(String itemId) {
    return _repo.deleteExchangeItem(itemId);
  }
}
