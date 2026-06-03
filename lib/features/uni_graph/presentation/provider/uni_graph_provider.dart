import 'package:flutter/foundation.dart';
import '../../domain/entities/uni_graph_entity.dart';
import '../../domain/usecases/get_graph_data_usecase.dart';

enum UniGraphStatus { initial, loading, loaded, error }

class UniGraphProvider extends ChangeNotifier {
  final GetGraphDataUsecase _usecase;

  UniGraphProvider({required GetGraphDataUsecase usecase}) : _usecase = usecase;

  UniGraphStatus _status = UniGraphStatus.initial;
  UniGraphStatus get status => _status;
  bool get isLoading => _status == UniGraphStatus.loading;

  List<UniNodeEntity> _nodes = [];
  List<UniNodeEntity> get nodes => _nodes;

  List<UniEdgeEntity> _edges = [];
  List<UniEdgeEntity> get edges => _edges;

  String? _error;
  String? get error => _error;

  Future<void> loadGraph() async {
    _status = UniGraphStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final result = await _usecase();
      _nodes = result.nodes;
      _edges = result.edges;
      _status = UniGraphStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = UniGraphStatus.error;
      _nodes = [];
      _edges = [];
    }
    notifyListeners();
  }
}
