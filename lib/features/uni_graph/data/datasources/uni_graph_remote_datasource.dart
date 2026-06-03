import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/uni_graph_entity.dart';

abstract class UniGraphRemoteDataSource {
  Future<({List<UniNodeEntity> nodes, List<UniEdgeEntity> edges})> getGraphData();
}

class UniGraphRemoteDataSourceImpl implements UniGraphRemoteDataSource {
  final SupabaseClient _client;

  UniGraphRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  @override
  Future<({List<UniNodeEntity> nodes, List<UniEdgeEntity> edges})> getGraphData() async {
    final data = await _client
        .from('universities')
        .select('id, name, activity_score')
        .order('activity_score', ascending: false);

    final unis = data as List;
    final count = unis.length;

    // Circular layout on 800×800 canvas, starting at 12 o'clock
    final nodes = List.generate(count, (i) {
      final angle = (2 * pi * i) / count - pi / 2;
      const cx = 400.0;
      const cy = 390.0;
      const r = 270.0;
      return UniNodeEntity(
        id: unis[i]['id'] as String,
        name: unis[i]['name'] as String,
        x: cx + r * cos(angle),
        y: cy + r * sin(angle),
        activityLevel: unis[i]['activity_score'] as int? ?? 0,
      );
    });

    // Connect each node to its 2 nearest neighbors by activity score (sorted chain)
    final sorted = List.of(nodes)
      ..sort((a, b) => a.activityLevel.compareTo(b.activityLevel));

    final edgeSet = <String, UniEdgeEntity>{};
    for (int i = 0; i < sorted.length; i++) {
      for (int j = i + 1; j <= min(i + 2, sorted.length - 1); j++) {
        final a = sorted[i];
        final b = sorted[j];
        final diff = (a.activityLevel - b.activityLevel).abs();
        final strength = max(0.0, 1.0 - diff / 40.0);
        final key = '${a.id}_${b.id}';
        edgeSet[key] = UniEdgeEntity(
          sourceId: a.id,
          targetId: b.id,
          strength: strength,
        );
      }
    }

    return (nodes: nodes, edges: edgeSet.values.toList());
  }
}
