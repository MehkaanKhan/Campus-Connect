import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/feed_provider.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          const CampusTopNavBar(),
          const _FeedHeader(),
          Expanded(child: _FeedBody()),
          const CampusBottomNavBar(activeTab: BottomNavTab.home),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create-post'),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Stanford University Feed',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 22),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Latest updates from your campus community.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.status == FeedStatus.error) {
      return Center(child: Text(provider.error ?? 'Error loading feed'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: provider.posts.length,
      itemBuilder: (ctx, i) => PostCard(post: provider.posts[i]),
    );
  }
}
