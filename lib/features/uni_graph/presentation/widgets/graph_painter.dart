import 'package:flutter/material.dart';
import '../../domain/entities/uni_graph_entity.dart';
import '../../../../core/constants/app_colors.dart';

class GraphPainter extends CustomPainter {
  final List<UniEdgeEntity> edges;
  final Map<String, Offset> positions;

  const GraphPainter({required this.edges, required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final edge in edges) {
      final src = positions[edge.sourceId];
      final tgt = positions[edge.targetId];
      if (src == null || tgt == null) continue;
      paint
        ..color = AppColors.graphEdge.withValues(alpha: 0.25 + edge.strength * 0.45)
        ..strokeWidth = 0.8 + edge.strength * 1.4;
      canvas.drawLine(src, tgt, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter old) =>
      old.positions != positions || old.edges != edges;
}
