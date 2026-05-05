import '../../domain/entities/exchange_item_entity.dart';
import '../../domain/repositories/hostellite_repository.dart';
import '../datasources/hostellite_local_datasource.dart';

class HostelliteRepositoryImpl implements HostelliteRepository {
  final HostelliteLocalDataSource _source;
  const HostelliteRepositoryImpl(this._source);

  @override
  Future<List<ExchangeItemEntity>> getItems({ItemType? filter}) async {
    final all = await _source.getItems();
    if (filter == null) return all;
    return all.where((i) => i.type == filter).toList();
  }
}
