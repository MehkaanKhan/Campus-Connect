import '../../domain/entities/exchange_item_entity.dart';
import '../../domain/repositories/hostellite_repository.dart';

class ListItemUsecase {
  final HostelliteRepository _repo;
  ListItemUsecase(this._repo);

  Future<void> call(ExchangeItemEntity item, {List<int>? imageBytes}) =>
      _repo.listItem(item, imageBytes: imageBytes);
}
