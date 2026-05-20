import '../../domain/entities/exchange_item_entity.dart';
import '../../domain/repositories/hostellite_repository.dart';
import '../datasources/hostellite_remote_datasource.dart';

class HostelliteRepositoryImpl implements HostelliteRepository {
  final HostelliteRemoteDataSource _source;
  const HostelliteRepositoryImpl(this._source);

  @override
  Future<List<ExchangeItemEntity>> getItems({ItemType? filter}) =>
      _source.getItems(filter: filter);
}
