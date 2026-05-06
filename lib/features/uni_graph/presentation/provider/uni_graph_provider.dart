import 'package:flutter/material.dart';
import '../../domain/entities/uni_graph_entity.dart';

class UniGraphProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UniNodeEntity> _nodes = [];
  List<UniNodeEntity> get nodes => _nodes;

  List<UniEdgeEntity> _edges = [];
  List<UniEdgeEntity> get edges => _edges;

  void loadGraph() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy data
    _nodes = [
      UniNodeEntity(id: '1', name: 'NUST', x: 200, y: 300, activityLevel: 90),
      UniNodeEntity(id: '2', name: 'FAST', x: 400, y: 150, activityLevel: 75),
      UniNodeEntity(id: '3', name: 'LUMS', x: 100, y: 100, activityLevel: 85),
      UniNodeEntity(id: '4', name: 'GIKI', x: 500, y: 400, activityLevel: 60),
      UniNodeEntity(id: '5', name: 'UET', x: 300, y: 500, activityLevel: 40),
      UniNodeEntity(id: '6', name: 'IBA', x: 600, y: 200, activityLevel: 70),
    ];

    _edges = [
      UniEdgeEntity(sourceId: '1', targetId: '2', strength: 0.8),
      UniEdgeEntity(sourceId: '1', targetId: '3', strength: 0.5),
      UniEdgeEntity(sourceId: '1', targetId: '5', strength: 0.3),
      UniEdgeEntity(sourceId: '2', targetId: '4', strength: 0.6),
      UniEdgeEntity(sourceId: '2', targetId: '6', strength: 0.4),
      UniEdgeEntity(sourceId: '4', targetId: '5', strength: 0.2),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
