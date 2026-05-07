import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../provider/carpool_provider.dart';

class CarpoolFeedPage extends StatefulWidget {
  const CarpoolFeedPage({super.key});

  @override
  State<CarpoolFeedPage> createState() => _CarpoolFeedPageState();
}

class _CarpoolFeedPageState extends State<CarpoolFeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarpoolProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Carpool & Rides',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const _FilterRow(),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const _DividerLine(),
                // ── List ────────────────────────────────────────────────────
                const Expanded(child: _RideList()),
              ],
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Filter chips
// ────────────────────────────────────────────────────────────────────────────

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  static const _filters = [
    (CarpoolFilter.all, 'All'),
    (CarpoolFilter.morning, 'Morning'),
    (CarpoolFilter.evening, 'Evening'),
    (CarpoolFilter.weekend, 'Weekend'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<CarpoolProvider>().filter;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((f) {
          final isActive = current == f.$1;
          return GestureDetector(
            onTap: () => context.read<CarpoolProvider>().setFilter(f.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF6B8F6B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF6B8F6B)
                      : const Color(0xFFDDDDD8),
                ),
              ),
              child: Text(
                f.$2,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF434942),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEE8));
}

// ────────────────────────────────────────────────────────────────────────────
// Ride list
// ────────────────────────────────────────────────────────────────────────────

class _RideList extends StatelessWidget {
  const _RideList();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarpoolProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.status == CarpoolStatus.error) {
      return Center(child: Text(provider.error ?? 'Error loading rides'));
    }
    final rides = provider.filtered;
    if (rides.isEmpty) {
      return const Center(
        child: Text(
          'No rides in this category',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: rides.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (ctx, i) => _RideCard(ride: rides[i]),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Ride card
// ────────────────────────────────────────────────────────────────────────────

class _RideCard extends StatelessWidget {
  final CarpoolRideEntity ride;
  const _RideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEE8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ride.from} to ${ride.to}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 13, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(
                            '${ride.time} ${ride.date}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Driver avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFF6B8F6B),
                  backgroundImage: ride.driverAvatarUrl != null
                      ? NetworkImage(ride.driverAvatarUrl!)
                      : null,
                  child: ride.driverAvatarUrl == null
                      ? Text(
                          ride.driverName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          // ── Map preview / route bar ─────────────────────────────────────
          _RouteVisual(ride: ride),
          const SizedBox(height: 12),
          // ── Seat indicators ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SeatRow(ride: ride),
          ),
          const SizedBox(height: 14),
          // ── Join button ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _JoinButton(ride: ride),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Route visual (map placeholder + duration badge)
// ────────────────────────────────────────────────────────────────────────────

class _RouteVisual extends StatelessWidget {
  final CarpoolRideEntity ride;
  const _RouteVisual({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 110,
              width: double.infinity,
              color: const Color(0xFFECF0E8),
              child: CustomPaint(
                painter: _MapDoodlePainter(),
              ),
            ),
          ),
          // Duration badge
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(8),
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
                  const Icon(Icons.route_outlined,
                      size: 13, color: Color(0xFF6B8F6B)),
                  const SizedBox(width: 4),
                  Text(
                    '${ride.estimatedMinutes} mins',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
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

/// Draws a simple dotted curved road to mimic a map route preview.
class _MapDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFB0BEAA)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFF6B8F6B)
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

    // Draw dashed road
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

    // Start dot
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

    // End dot
    final endT =
        pathMetrics.getTangentForOffset(pathMetrics.length);
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

// ────────────────────────────────────────────────────────────────────────────
// Seat row icons
// ────────────────────────────────────────────────────────────────────────────

class _SeatRow extends StatelessWidget {
  final CarpoolRideEntity ride;
  const _SeatRow({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < ride.totalSeats; i++)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              i < ride.takenSeats
                  ? Icons.person_off_outlined
                  : Icons.person_outline_rounded,
              size: 20,
              color: i < ride.takenSeats
                  ? const Color(0xFFCCCCCA)
                  : const Color(0xFF6B8F6B),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          '${ride.seatsAvailable} seat${ride.seatsAvailable == 1 ? '' : 's'} available',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF434942),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Join button
// ────────────────────────────────────────────────────────────────────────────

class _JoinButton extends StatelessWidget {
  final CarpoolRideEntity ride;
  const _JoinButton({required this.ride});

  @override
  Widget build(BuildContext context) {
    final joined = ride.hasJoined;
    final noSeats = ride.seatsAvailable == 0;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: (joined || noSeats)
            ? null
            : () => context.read<CarpoolProvider>().joinRide(ride.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: joined
                ? const Color(0xFF6B8F6B)
                : noSeats
                    ? const Color(0xFFEEEEE8)
                    : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              joined
                  ? '✓ Joined'
                  : noSeats
                      ? 'Fully Booked'
                      : 'Join Ride',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: noSeats && !joined
                    ? const Color(0xFFAAAAAA)
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
