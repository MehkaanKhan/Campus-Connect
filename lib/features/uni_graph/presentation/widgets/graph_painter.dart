import 'package:flutter/material.dart';
import '../../domain/entities/uni_graph_entity.dart';
import '../../../../core/constants/app_colors.dart';

class GraphPainter extends CustomPainter {
  final List<UniNodeEntity> nodes;
  final List<UniEdgeEntity> edges;

  GraphPainter({required this.nodes, required this.edges});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final edgePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final heatmapPaint = Paint()
      ..style = PaintingStyle.fill;

    final nodeBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw Edges
    for (final edge in edges) {
      final source = nodes.firstWhere((n) => n.id == edge.sourceId);
      final target = nodes.firstWhere((n) => n.id == edge.targetId);

      edgePaint.strokeWidth = 1.0 + (edge.strength * 4);
      canvas.drawLine(
        Offset(source.x, source.y),
        Offset(target.x, target.y),
        edgePaint,
      );
    }

    // Draw Heatmap / Nodes
    for (final node in nodes) {
      final center = Offset(node.x, node.y);

      // Heatmap glow
      final double radius = 30.0 + (node.activityLevel * 0.5);
      heatmapPaint.shader = RadialGradient(
        colors: [
          AppColors.accent.withValues(alpha: 0.4 * (node.activityLevel / 100)),
          AppColors.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
      
      canvas.drawCircle(center, radius, heatmapPaint);

      // Node Circle
      final nodePaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, 15, nodePaint);
      canvas.drawCircle(center, 15, nodeBorderPaint);

      // Node Label
      textPainter.text = TextSpan(
        text: node.name,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - (textPainter.width / 2), center.dy + 20),
      );
      
      // Node Activity Badge
      textPainter.text = TextSpan(
        text: '${node.activityLevel}',
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          fontFamily: 'Inter',
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - (textPainter.width / 2), center.dy - 35),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.edges != edges;
  }
}
