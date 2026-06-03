import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';

class UniGraphShimmer extends StatelessWidget {
  const UniGraphShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1200),
      child: CustomPaint(
        painter: _GraphShimmerPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GraphShimmerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) * 0.36;
    const nodeCount = 10;
    const nodeR = 20.0;

    final positions = List.generate(nodeCount, (i) {
      final angle = (2 * pi * i) / nodeCount - pi / 2;
      return Offset(cx + r * cos(angle), cy + r * sin(angle));
    });

    final edgePaint = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw connecting lines between neighbors
    for (int i = 0; i < nodeCount; i++) {
      canvas.drawLine(positions[i], positions[(i + 1) % nodeCount], edgePaint);
      canvas.drawLine(positions[i], positions[(i + 3) % nodeCount], edgePaint);
    }

    final nodePaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    final labelPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    for (final pos in positions) {
      // Node circle
      canvas.drawCircle(pos, nodeR, nodePaint);

      // Score placeholder above node
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(pos.dx, pos.dy - nodeR - 10),
            width: 22,
            height: 9,
          ),
          const Radius.circular(4),
        ),
        labelPaint,
      );

      // Name label placeholder below node
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(pos.dx, pos.dy + nodeR + 10),
            width: 54,
            height: 9,
          ),
          const Radius.circular(4),
        ),
        labelPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(pos.dx, pos.dy + nodeR + 24),
            width: 38,
            height: 9,
          ),
          const Radius.circular(4),
        ),
        labelPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
