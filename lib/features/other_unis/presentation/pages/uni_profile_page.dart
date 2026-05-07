import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../domain/entities/other_uni_entity.dart';

class UniProfilePage extends StatelessWidget {
  final OtherUniEntity uni;

  const UniProfilePage({super.key, required this.uni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero header ────────────────────────────────────────
                  _HeroHeader(uni: uni),
                  const SizedBox(height: 16),

                  // ── Stats row ──────────────────────────────────────────
                  _StatsRow(uni: uni),
                  const SizedBox(height: 16),

                  // ── About section ──────────────────────────────────────
                  _AboutSection(uni: uni),
                  const SizedBox(height: 16),

                  // ── Top clubs ───────────────────────────────────────────
                  const _TopClubsSection(),
                  const SizedBox(height: 16),

                  // ── Recent posts (view-only) ───────────────────────────
                  _RecentPostsSection(uniName: uni.name),
                  const SizedBox(height: 16),

                  // ── View-only notice ───────────────────────────────────
                  const _ViewOnlyBanner(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero header with gradient + logo + name
// ─────────────────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final OtherUniEntity uni;
  const _HeroHeader({required this.uni});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1C19), Color(0xFF2E3D2E)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBE8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: Center(
              child: Text(
                uni.logoText,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF98A895),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            uni.name,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            uni.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF98A895)),
                const SizedBox(width: 4),
                Text(
                  uni.region,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF98A895),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats row – 4 metric tiles
// ─────────────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final OtherUniEntity uni;
  const _StatsRow({required this.uni});

  @override
  Widget build(BuildContext context) {
    final clubs = (uni.memberCount * 0.01).toInt();
    final posts = (uni.memberCount * 0.08).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatTile(value: '${uni.memberCount}', label: 'Members', icon: Icons.people_outline),
          const SizedBox(width: 10),
          _StatTile(value: '${uni.activityScore}', label: 'Activity', icon: Icons.trending_up_rounded),
          const SizedBox(width: 10),
          _StatTile(value: '$clubs', label: 'Clubs', icon: Icons.groups_outlined),
          const SizedBox(width: 10),
          _StatTile(value: '$posts', label: 'Posts', icon: Icons.article_outlined),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatTile({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEE8)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF98A895)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1C19),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About section
// ─────────────────────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  final OtherUniEntity uni;
  const _AboutSection({required this.uni});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C19),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${uni.description} — a leading institution in ${uni.region} with ${uni.memberCount} active community members and an activity score of ${uni.activityScore}/100.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF434940),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.verified_outlined, text: 'Verified'),
              _InfoChip(icon: Icons.school_outlined, text: uni.region),
              _InfoChip(icon: Icons.star_outline_rounded, text: 'Score: ${uni.activityScore}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF98A895)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF434940),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top clubs – horizontal scroll
// ─────────────────────────────────────────────────────────────────────────────
class _TopClubsSection extends StatelessWidget {
  const _TopClubsSection();

  static const _clubs = [
    {'name': 'Tech Society', 'icon': Icons.computer_outlined, 'members': '320'},
    {'name': 'Drama Club', 'icon': Icons.theater_comedy_outlined, 'members': '180'},
    {'name': 'Sports Council', 'icon': Icons.sports_soccer_outlined, 'members': '450'},
    {'name': 'Debate Society', 'icon': Icons.record_voice_over_outlined, 'members': '210'},
    {'name': 'Music Club', 'icon': Icons.music_note_outlined, 'members': '150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Top Clubs',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C19),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _clubs.length,
            separatorBuilder: (c, i) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final club = _clubs[index];
              return Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEEEE8)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(club['icon'] as IconData, size: 22, color: const Color(0xFF98A895)),
                    const SizedBox(height: 8),
                    Text(
                      club['name'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1C19),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${club['members']} members',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent posts – view-only feed cards
// ─────────────────────────────────────────────────────────────────────────────
class _RecentPostsSection extends StatelessWidget {
  final String uniName;
  const _RecentPostsSection({required this.uniName});

  @override
  Widget build(BuildContext context) {
    final posts = [
      _MockPost(
        author: 'Admin · $uniName',
        time: '2h ago',
        title: 'Spring semester registrations now open',
        body: 'All students are advised to complete their course registrations before the deadline. Check the portal for available electives.',
        flair: 'Academic',
        flairColor: const Color(0xFFFED9B8),
      ),
      _MockPost(
        author: 'Student Council',
        time: '5h ago',
        title: 'Annual sports gala next week',
        body: 'Sign up for cricket, football, and badminton tournaments. Prizes worth PKR 50,000 to be won!',
        flair: 'Events',
        flairColor: const Color(0xFFD6D6EA),
      ),
      _MockPost(
        author: 'CS Department',
        time: '1d ago',
        title: 'Guest lecture on AI & Machine Learning',
        body: 'Join us this Friday for an insightful session with Dr. Ahmed on the latest trends in artificial intelligence.',
        flair: 'Academic',
        flairColor: const Color(0xFFFED9B8),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Posts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1C19),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...posts.map((post) => _ViewOnlyPostCard(post: post)),
      ],
    );
  }
}

class _MockPost {
  final String author;
  final String time;
  final String title;
  final String body;
  final String flair;
  final Color flairColor;

  const _MockPost({
    required this.author,
    required this.time,
    required this.title,
    required this.body,
    required this.flair,
    required this.flairColor,
  });
}

class _ViewOnlyPostCard extends StatelessWidget {
  final _MockPost post;
  const _ViewOnlyPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFEBEBE8),
                child: Text(
                  post.author[0],
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF98A895),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  post.author,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C19),
                  ),
                ),
              ),
              Text(
                post.time,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Flair chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: post.flairColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              post.flair,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF434940),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            post.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: Color(0xFF1A1C19),
            ),
          ),
          const SizedBox(height: 4),
          // Body
          Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          // Read-only interaction bar
          Row(
            children: [
              Icon(Icons.favorite_border_rounded, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('—', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
              const SizedBox(width: 16),
              Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('—', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View-only notice banner
// ─────────────────────────────────────────────────────────────────────────────
class _ViewOnlyBanner extends StatelessWidget {
  const _ViewOnlyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2EF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEE8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF98A895)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'View-Only Mode',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C19),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'You are browsing another university. Interactions are disabled.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
