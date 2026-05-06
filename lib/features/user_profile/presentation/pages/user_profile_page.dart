import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../provider/user_profile_provider.dart';

const _kGreen      = Color(0xFF6B8F6B);
const _kGray       = Color(0xFF94A3B8);
const _kDark       = Color(0xFF1A1A1A);

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().load('me');
    });
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
      body: Column(
        children: [
          const CampusTopNavBar(),
          Expanded(child: _ProfileBody(tabController: _tabController)),
          const CampusBottomNavBar(activeTab: BottomNavTab.profile),
        ],
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final TabController tabController;
  const _ProfileBody({required this.tabController});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProfileProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.profile == null) {
      return const Center(
        child: Text('Profile not found', style: TextStyle(color: _kGray)),
      );
    }
    final p = provider.profile!;
    return NestedScrollView(
      headerSliverBuilder: (ctx, _) => [
        SliverToBoxAdapter(child: _ProfileCard(profile: p)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(tabController),
        ),
      ],
      body: TabBarView(
        controller: tabController,
        children: [
          _PostsList(posts: p.posts),
          _PostsList(posts: p.reactedPosts, emptyLabel: 'No reacted posts yet'),
          _CarpoolsList(carpools: p.joinedCarpools),
        ],
      ),
    );
  }
}

// ── Unified white profile card (avatar + name + bio + stats) ──────────────────
class _ProfileCard extends StatelessWidget {
  final UserProfileEntity profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFD6D6EA),
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? Text(
                        profile.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      )
                    : null,
              ),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kGreen,
                ),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _kDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 5),

          // Department + year
          Text(
            '${profile.department}, ${profile.year}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Color(0xFF888880),
            ),
          ),
          const SizedBox(height: 16),

          // Bio card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF3F3F46),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Stats
          Row(
            children: [
              Expanded(
                child: _StatItem(value: '${profile.postCount}', label: 'POSTS', color: _kGreen),
              ),
              Container(width: 1, height: 34, color: const Color(0xFFEEEEE8)),
              Expanded(
                child: _StatItem(value: '${profile.karma}', label: 'KARMA', color: const Color(0xFFA895A0)),
              ),
              Container(width: 1, height: 34, color: const Color(0xFFEEEEE8)),
              Expanded(
                child: _StatItem(value: '${profile.ridesCount}', label: 'RIDES', color: _kGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({required this.value, required this.label, this.color = _kGreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: _kGray,
          ),
        ),
      ],
    );
  }
}

// ── Pinned tab bar ─────────────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  const _TabBarDelegate(this.controller);

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelColor: _kDark,
        unselectedLabelColor: _kGray,
        indicatorColor: _kGreen,
        indicatorWeight: 2.5,
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Reactions'),
          Tab(text: 'Joined Carpools'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => false;
}

// ── Post list ─────────────────────────────────────────────────────────────────
class _PostsList extends StatelessWidget {
  final List<ProfilePostEntity> posts;
  final String emptyLabel;
  const _PostsList({required this.posts, this.emptyLabel = 'No posts yet'});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: const TextStyle(color: _kGray)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      itemCount: posts.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _ProfilePostCard(post: posts[i]),
      ),
    );
  }
}

class _ProfilePostCard extends StatelessWidget {
  final ProfilePostEntity post;
  const _ProfilePostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flair + time ago
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEE8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  post.flair,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF888880),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                post.timeAgo,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: _kGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            post.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _kDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),

          // Excerpt
          Text(
            post.excerpt,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xFF666660),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Actions — right-aligned
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.thumb_up_outlined, size: 15, color: Color(0xFF888880)),
              const SizedBox(width: 4),
              Text(
                '${post.upvotes}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF888880),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF888880)),
              const SizedBox(width: 4),
              Text(
                '${post.commentCount}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: Color(0xFF888880),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Carpools list ──────────────────────────────────────────────────────────────
class _CarpoolsList extends StatelessWidget {
  final List<String> carpools;
  const _CarpoolsList({required this.carpools});

  @override
  Widget build(BuildContext context) {
    if (carpools.isEmpty) {
      return const Center(
        child: Text('No carpools joined yet', style: TextStyle(color: _kGray)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: carpools.length,
      itemBuilder: (ctx, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE2E9E0),
              child: Icon(Icons.directions_car_outlined, size: 16, color: _kGreen),
            ),
            const SizedBox(width: 12),
            Text(
              carpools[i],
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _kDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
