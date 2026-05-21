import '../repositories/exchange_board_repository.dart';

class UpdateItemAvailabilityUsecase {
  final ExchangeBoardRepository _repo;

  const UpdateItemAvailabilityUsecase(this._repo);

  Future<void> call({
    required String itemId,
    required bool isAvailable,
  }) {
    return _repo.updateItemAvailability(
      itemId: itemId,
      isAvailable: isAvailable,
    );
  }
}
