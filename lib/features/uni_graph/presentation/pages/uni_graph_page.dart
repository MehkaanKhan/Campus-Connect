import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../domain/entities/uni_graph_entity.dart';
import '../provider/uni_graph_provider.dart';
import '../widgets/graph_painter.dart';
import '../widgets/uni_graph_shimmer.dart';

class UniGraphPage extends StatefulWidget {
  const UniGraphPage({super.key});

  @override
  State<UniGraphPage> createState() => _UniGraphPageState();
}

class _UniGraphPageState extends State<UniGraphPage> {
  final _txController = TransformationController();
  final Map<String, Offset> _nodePos = {};
  bool _posReady = false;
  bool _transformSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UniGraphProvider>().loadGraph();
    });
  }

  @override
  void dispose() {
    _txController.dispose();
    super.dispose();
  }

  void _initPositions(List<UniNodeEntity> nodes) {
    if (_posReady) return;
    for (final n in nodes) {
      _nodePos[n.id] = Offset(n.x, n.y);
    }
    _posReady = true;
  }

  void _fitCanvas(BoxConstraints constraints) {
    if (_transformSet) return;
    _transformSet = true;
    final s = min(constraints.maxWidth / 800.0, constraints.maxHeight / 800.0) * 0.9;
    final tx = (constraints.maxWidth - 800.0 * s) / 2.0;
    final ty = (constraints.maxHeight - 800.0 * s) / 2.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Construct scale+translate matrix: screen = s*canvas + t
      final m = Matrix4.identity();
      m.setEntry(0, 0, s);
      m.setEntry(1, 1, s);
      m.setEntry(0, 3, tx);
      m.setEntry(1, 3, ty);
      _txController.value = m;
    });
  }

  void _zoom(double factor) {
    final currentScale = _txController.value.getMaxScaleOnAxis();
    final newScale = (currentScale * factor).clamp(0.2, 4.0);
    final actualFactor = newScale / currentScale;
    if ((actualFactor - 1.0).abs() < 0.001) return;

    // Zoom around the screen-projected position of the canvas centre
    final screenCenter = MatrixUtils.transformPoint(
      _txController.value,
      const Offset(400, 390),
    );
    final zoomMatrix = Matrix4.identity()
      ..translateByDouble(screenCenter.dx, screenCenter.dy, 0, 1)
      ..scaleByDouble(actualFactor, actualFactor, 1, 1)
      ..translateByDouble(-screenCenter.dx, -screenCenter.dy, 0, 1);
    _txController.value = zoomMatrix * _txController.value;
  }

  void _retryLoad(UniGraphProvider provider) {
    setState(() {
      _posReady = false;
      _transformSet = false;
      _nodePos.clear();
    });
    provider.loadGraph();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CampusTopNavBar(
          onBack: context.canPop() ? () => context.pop() : null,
          trailing: const SizedBox.shrink(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uni Graph',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'University activity network — drag nodes, pinch to zoom.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<UniGraphProvider>(
              builder: (ctx, provider, _) {
                if (provider.isLoading) {
                  return const UniGraphShimmer();
                }
                if (provider.status == UniGraphStatus.error) {
                  return ErrorState(
                    message: provider.error,
                    onRetry: () => _retryLoad(provider),
                  );
                }
                if (provider.nodes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No graph data available.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                }

                _initPositions(provider.nodes);

                return LayoutBuilder(
                  builder: (ctx, constraints) {
                    _fitCanvas(constraints);
                    return ClipRect(
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            transformationController: _txController,
                            constrained: false,
                            boundaryMargin: const EdgeInsets.all(double.infinity),
                            minScale: 0.2,
                            maxScale: 4.0,
                            child: SizedBox(
                              width: 800,
                              height: 800,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned.fill(
                                    child: Container(color: AppColors.pageBg),
                                  ),
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: GraphPainter(
                                        edges: provider.edges,
                                        positions: Map.unmodifiable(_nodePos),
                                      ),
                                    ),
                                  ),
                                  for (final node in provider.nodes)
                                    _buildNode(node),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Column(
                              children: [
                                _ZoomButton(
                                  icon: Icons.add,
                                  onTap: () => _zoom(1.3),
                                ),
                                const SizedBox(height: 6),
                                _ZoomButton(
                                  icon: Icons.remove,
                                  onTap: () => _zoom(1 / 1.3),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.open_with_rounded,
                                      size: 14,
                                      color: AppColors.textMuted,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Drag nodes · Pinch to zoom',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(UniNodeEntity node) {
    const r = 26.0;
    return Positioned(
      left: _nodePos[node.id]!.dx - r,
      top: _nodePos[node.id]!.dy - r,
      child: GestureDetector(
        onPanUpdate: (d) {
          final scale = _txController.value.getMaxScaleOnAxis();
          setState(() {
            final cur = _nodePos[node.id]!;
            _nodePos[node.id] = cur + d.delta / scale;
          });
        },
        child: _NodeWidget(node: node, radius: r),
      ),
    );
  }
}

class _NodeWidget extends StatelessWidget {
  final UniNodeEntity node;
  final double radius;

  const _NodeWidget({required this.node, required this.radius});

  String get _abbrev {
    const skip = {'of', 'the', 'and', 'at', 'for', 'a', 'an', 'in', 'i', 'e'};
    final name = node.name.trim();
    if (name.length <= 5 && !name.contains(' ')) return name.toUpperCase();
    final parts = name.split(RegExp(r'[\s\-\/]+'));
    final buf = StringBuffer();
    for (final p in parts) {
      if (p.isEmpty || skip.contains(p.toLowerCase())) continue;
      buf.write(p[0].toUpperCase());
      if (buf.length >= 4) break;
    }
    return buf.toString();
  }

  Color get _nodeColor {
    final lvl = node.activityLevel;
    if (lvl >= 75) return AppColors.primary;
    if (lvl >= 55) return const Color(0xFF3D6B52);
    return const Color(0xFF5A8C6E);
  }

  @override
  Widget build(BuildContext context) {
    final d = radius * 2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: d,
          height: d,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _nodeColor,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 8,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _abbrev,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 72,
          child: Text(
            node.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ),
        Text(
          '${node.activityLevel}',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
