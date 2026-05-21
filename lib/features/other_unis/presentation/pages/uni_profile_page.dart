import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../domain/entities/other_uni_entity.dart';

class UniProfilePage extends StatelessWidget {
  final OtherUniEntity uni;
  const UniProfilePage({super.key, required this.uni});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.pageBg,
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
                  _HeroHeader(uni: uni),
                  SizedBox(height: 16.h),
                  _StatsRow(uni: uni),
                  SizedBox(height: 16.h),
                  _AboutSection(uni: uni),
                  SizedBox(height: 16.h),
                  const _TopClubsSection(),
                  SizedBox(height: 16.h),
                  _RecentPostsSection(uniName: uni.name),
                  SizedBox(height: 16.h),
                  const _ViewOnlyBanner(),
                  SizedBox(height: 24.h),
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
// Hero header
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
          colors: [AppColors.textDark, AppColors.darkCardBg],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 32.h),
      child: Column(
        children: [
          Hero(
            tag: 'uni_logo_${uni.id}',
            child: Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: AppColors.avatarWarmGray,
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  uni.logoText,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.filterActiveBg,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            uni.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            uni.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14.w, color: AppColors.filterActiveBg),
                SizedBox(width: 4.w),
                Text(
                  uni.region,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.filterActiveBg,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _StatTile(
              value: '${uni.memberCount}',
              label: 'Members',
              icon: Icons.people_outline),
          SizedBox(width: 10.w),
          _StatTile(
              value: '${uni.activityScore}',
              label: 'Activity',
              icon: Icons.trending_up_rounded),
          SizedBox(width: 10.w),
          _StatTile(
              value: '$clubs', label: 'Clubs', icon: Icons.groups_outlined),
          SizedBox(width: 10.w),
          _StatTile(
              value: '$posts',
              label: 'Posts',
              icon: Icons.article_outlined),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatTile(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18.w, color: AppColors.filterActiveBg),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.textMuted,
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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            '${uni.description} — a leading institution in ${uni.region} with ${uni.memberCount} active community members and an activity score of ${uni.activityScore}/100.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5.sp,
              height: 1.6,
              color: AppColors.filterInactiveText,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _InfoChip(icon: Icons.verified_outlined, text: 'Verified'),
              _InfoChip(icon: Icons.school_outlined, text: uni.region),
              _InfoChip(
                  icon: Icons.star_outline_rounded,
                  text: 'Score: ${uni.activityScore}'),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.disabledBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: AppColors.filterActiveBg),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.filterInactiveText,
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
    {
      'name': 'Drama Club',
      'icon': Icons.theater_comedy_outlined,
      'members': '180'
    },
    {
      'name': 'Sports Council',
      'icon': Icons.sports_soccer_outlined,
      'members': '450'
    },
    {
      'name': 'Debate Society',
      'icon': Icons.record_voice_over_outlined,
      'members': '210'
    },
    {
      'name': 'Music Club',
      'icon': Icons.music_note_outlined,
      'members': '150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Top Clubs',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 108.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _clubs.length,
            separatorBuilder: (c, i) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final club = _clubs[index];
              return Container(
                width: 115.w,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(club['icon'] as IconData,
                        size: 22.w, color: AppColors.filterActiveBg),
                    SizedBox(height: 7.h),
                    Text(
                      club['name'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${club['members']} members',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        color: AppColors.textMuted,
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
        body:
            'All students are advised to complete their course registrations before the deadline. Check the portal for available electives.',
        flair: 'Academic',
        flairColor: AppColors.flairAcademic,
      ),
      _MockPost(
        author: 'Student Council',
        time: '5h ago',
        title: 'Annual sports gala next week',
        body:
            'Sign up for cricket, football, and badminton tournaments. Prizes worth PKR 50,000 to be won!',
        flair: 'Events',
        flairColor: AppColors.flairEvents,
      ),
      _MockPost(
        author: 'CS Department',
        time: '1d ago',
        title: 'Guest lecture on AI & Machine Learning',
        body:
            'Join us this Friday for an insightful session with Dr. Ahmed on the latest trends in artificial intelligence.',
        flair: 'Academic',
        flairColor: AppColors.flairAcademic,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Recent Posts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: 10.h),
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
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.avatarWarmGray,
                child: Text(
                  post.author[0],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.filterActiveBg,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  post.author,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Text(
                post.time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Flair chip
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: post.flairColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              post.flair,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.filterInactiveText,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          // Title
          Text(
            post.title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 4.h),
          // Body
          Text(
            post.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5.sp,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 10.h),
          // Read-only interaction bar
          Row(
            children: [
              Icon(Icons.favorite_border_rounded,
                  size: 16.w, color: AppColors.textMuted),
              SizedBox(width: 4.w),
              Text('—',
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textMuted)),
              SizedBox(width: 14.w),
              Icon(Icons.chat_bubble_outline_rounded,
                  size: 16.w, color: AppColors.textMuted),
              SizedBox(width: 4.w),
              Text('—',
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textMuted)),
              const Spacer(),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.filterInactiveBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined,
                        size: 12.w, color: AppColors.textMuted),
                    SizedBox(width: 4.w),
                    Text(
                      'View only',
                      style: TextStyle(
                          fontSize: 10.sp, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.sageLight,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_outlined,
              size: 18.w, color: AppColors.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View-Only Mode',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'You are browsing another university. Interactions are disabled.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5.sp,
                    color: AppColors.textMuted,
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
