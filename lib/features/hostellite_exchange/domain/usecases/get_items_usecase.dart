import '../entities/exchange_item_entity.dart';
import '../repositories/hostellite_repository.dart';

class GetExchangeItemsUsecase {
  final HostelliteRepository _repo;
  const GetExchangeItemsUsecase(this._repo);

  Future<List<ExchangeItemEntity>> call({ItemType? filter}) =>
      _repo.getItems(filter: filter);
}
