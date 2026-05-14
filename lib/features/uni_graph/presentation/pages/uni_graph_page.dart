import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/uni_graph_provider.dart';
import '../widgets/graph_painter.dart';

class UniGraphPage extends StatefulWidget {
  const UniGraphPage({super.key});

  @override
  State<UniGraphPage> createState() => _UniGraphPageState();
}

class _UniGraphPageState extends State<UniGraphPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UniGraphProvider>().loadGraph();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CampusTopNavBar(
          onBack: context.canPop() ? () => context.pop() : null,
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
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Interactive map showing university activity networks.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<UniGraphProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: AppLoader());
                }

                return ClipRRect(
                  child: Stack(
                    children: [
                      // Pseudo Map Background
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.05,
                          child: GridPaper(
                            color: Colors.blueAccent,
                            divisions: 2,
                            subdivisions: 2,
                          ),
                        ),
                      ),
                      InteractiveViewer(
                        constrained: false,
                        boundaryMargin: const EdgeInsets.all(500),
                        minScale: 0.1,
                        maxScale: 3.0,
                        child: CustomPaint(
                          size: const Size(1000, 1000), // Large virtual canvas
                          painter: GraphPainter(
                            nodes: provider.nodes,
                            edges: provider.edges,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pinch, color: Color(0xFF94A3B8)),
                              SizedBox(width: 8),
                              Text(
                                'Pinch to zoom, drag to pan',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
