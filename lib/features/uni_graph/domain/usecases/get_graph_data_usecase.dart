import '../entities/uni_graph_entity.dart';
import '../repositories/uni_graph_repository.dart';

class GetGraphDataUsecase {
  final UniGraphRepository _repo;

  GetGraphDataUsecase(this._repo);

  Future<({List<UniNodeEntity> nodes, List<UniEdgeEntity> edges})> call() =>
      _repo.getGraphData();
}
