import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/carpool_ride_entity.dart';

class CarpoolRouteVisual extends StatelessWidget {
  final CarpoolRideEntity ride;
  const CarpoolRouteVisual({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              height: 110.h,
              width: double.infinity,
              color: AppColors.carpoolMapBg,
              child: const CustomPaint(
                painter: _MapDoodlePainter(),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.route_outlined, size: 13.w, color: AppColors.sage),
                  SizedBox(width: 4.w),
                  Text(
                    '${ride.estimatedMinutes} mins',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapDoodlePainter extends CustomPainter {
  const _MapDoodlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = AppColors.carpoolRoute
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = AppColors.sage
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.2,
        size.width * 0.6,
        size.height * 0.9,
        size.width * 0.9,
        size.height * 0.3,
      );

    final pathMetrics = path.computeMetrics().first;
    double distance = 0;
    const dash = 10.0, gap = 6.0;
    while (distance < pathMetrics.length) {
      final start = pathMetrics.getTangentForOffset(distance);
      final end = pathMetrics.getTangentForOffset(
          (distance + dash).clamp(0, pathMetrics.length));
      if (start != null && end != null) {
        canvas.drawLine(start.position, end.position, roadPaint);
      }
      distance += dash + gap;
    }

    final startT = pathMetrics.getTangentForOffset(0);
    if (startT != null) {
      canvas.drawCircle(startT.position, 6, dotPaint);
      canvas.drawCircle(
          startT.position,
          6,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }

    final endT = pathMetrics.getTangentForOffset(pathMetrics.length);
    if (endT != null) {
      canvas.drawCircle(endT.position, 6, dotPaint);
      canvas.drawCircle(
          endT.position,
          6,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
