import '../../domain/entities/uni_graph_entity.dart';
import '../../domain/repositories/uni_graph_repository.dart';
import '../datasources/uni_graph_remote_datasource.dart';

class UniGraphRepositoryImpl implements UniGraphRepository {
  final UniGraphRemoteDataSource _datasource;

  UniGraphRepositoryImpl(this._datasource);

  @override
  Future<({List<UniNodeEntity> nodes, List<UniEdgeEntity> edges})> getGraphData() =>
      _datasource.getGraphData();
}
