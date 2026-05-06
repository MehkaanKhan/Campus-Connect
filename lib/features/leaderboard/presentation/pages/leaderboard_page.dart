import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/leaderboard_provider.dart';
import '../widgets/podium_widget.dart';
import '../widgets/leaderboard_list_item.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['This Week', 'This Month', 'All Time'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().loadLeaderboard(_tabs[0]);
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      context.read<LeaderboardProvider>().loadLeaderboard(_tabs[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF1E3A8A),
                  labelColor: const Color(0xFF1E3A8A),
                  unselectedLabelColor: const Color(0xFF94A3B8),
                  labelStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<LeaderboardProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: AppLoader());
                }

                if (provider.users.isEmpty) {
                  return const Center(child: Text('No ranking available.'));
                }

                final topThree = provider.users.take(3).toList();
                final others = provider.users.skip(3).toList();

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: PodiumWidget(topThree: topThree),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return LeaderboardListItem(
                            user: others[index],
                            rank: index + 4,
                          );
                        },
                        childCount: others.length,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 20),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
