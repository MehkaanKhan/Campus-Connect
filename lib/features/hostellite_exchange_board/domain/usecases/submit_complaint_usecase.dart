import '../repositories/exchange_board_repository.dart';

class SubmitComplaintUsecase {
  final ExchangeBoardRepository _repo;

  const SubmitComplaintUsecase(this._repo);

  Future<void> call({
    required String itemId,
    required String reason,
    required String details,
  }) {
    return _repo.submitComplaint(
      itemId: itemId,
      reason: reason,
      details: details,
    );
  }
}
