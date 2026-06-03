import '../entities/uni_graph_entity.dart';

abstract class UniGraphRepository {
  Future<({List<UniNodeEntity> nodes, List<UniEdgeEntity> edges})> getGraphData();
}
