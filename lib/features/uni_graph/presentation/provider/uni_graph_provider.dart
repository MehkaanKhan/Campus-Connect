import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/uni_graph_entity.dart';

class UniGraphProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UniNodeEntity> _nodes = [];
  List<UniNodeEntity> get nodes => _nodes;

  List<UniEdgeEntity> _edges = [];
  List<UniEdgeEntity> get edges => _edges;

  Future<void> loadGraph() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await SupabaseService.client
          .from('universities')
          .select('id, name, activity_score')
          .order('activity_score', ascending: false);

      final unis = data as List;
      final count = unis.length;

      // Distribute nodes in a circle
      _nodes = List.generate(count, (i) {
        final angle = (2 * pi * i) / count;
        const cx = 300.0;
        const cy = 300.0;
        const r = 220.0;
        return UniNodeEntity(
          id: unis[i]['id'] as String,
          name: unis[i]['name'] as String,
          x: cx + r * cos(angle),
          y: cy + r * sin(angle),
          activityLevel: unis[i]['activity_score'] as int? ?? 0,
        );
      });

      // Build edges between nodes whose activity scores are within 20 points
      _edges = [];
      for (int i = 0; i < _nodes.length; i++) {
        for (int j = i + 1; j < _nodes.length; j++) {
          final diff = (_nodes[i].activityLevel - _nodes[j].activityLevel).abs();
          if (diff <= 20) {
            _edges.add(UniEdgeEntity(
              sourceId: _nodes[i].id,
              targetId: _nodes[j].id,
              strength: 1 - (diff / 20),
            ));
          }
        }
      }
    } on PostgrestException catch (e) {
      debugPrint('UniGraph error: ${e.message}');
      _nodes = [];
      _edges = [];
    } catch (e) {
      debugPrint('UniGraph error: $e');
      _nodes = [];
      _edges = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
