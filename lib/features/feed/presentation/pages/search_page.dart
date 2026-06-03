import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/post_card.dart';
import '../widgets/post_card_shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _client = SupabaseService.client;

  Timer? _debounce;
  List<PostEntity> _results = [];
  bool _loading = false;
  bool _hasSearched = false;
  String? _universityId;

  @override
  void initState() {
    super.initState();
    _resolveUniversity();
  }

  Future<void> _resolveUniversity() async {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return;
    final row = await _client
        .from('profiles')
        .select('university_id')
        .eq('id', userId)
        .maybeSingle();
    _universityId = row?['university_id'] as String?;
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query.trim()));
  }

  Future<void> _search(String query) async {
    if (_universityId == null) return;
    setState(() { _loading = true; _hasSearched = true; });

    final response = await _client
        .from('posts')
        .select('''
          id, title, content, image_url, flair,
          upvote_count, downvote_count, comment_count, created_at,
          profiles!author_id(full_name, avatar_url)
        ''')
        .eq('university_id', _universityId!)
        .or('title.ilike.%$query%,content.ilike.%$query%')
        .order('created_at', ascending: false)
        .limit(30);

    final posts = (response as List).map((data) {
      final author = data['profiles'] as Map?;
      final createdAt = DateTime.parse(data['created_at'])
          .subtract(const Duration(minutes: 10));
      final diff = DateTime.now().difference(createdAt);
      final String timeAgo;
      if (diff.inDays > 0) {
        timeAgo = '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        timeAgo = '${diff.inMinutes}m ago';
      } else {
        timeAgo = 'Just now';
      }

      return PostEntity(
        id: data['id'] as String,
        authorName: author?['full_name'] ?? 'Unknown',
        authorAvatarUrl: author?['avatar_url'] as String?,
        timeAgo: timeAgo,
        flair: data['flair'] ?? 'General',
        flairColor: data['flair'] as String? ?? 'General',
        title: data['title'] ?? '',
        excerpt: data['content'] ?? '',
        imageUrl: data['image_url'] as String?,
        upvotes: data['upvote_count'] ?? 0,
        downvotes: data['downvote_count'] ?? 0,
        commentCount: data['comment_count'] ?? 0,
      );
    }).toList();

    if (mounted) setState(() { _results = posts; _loading = false; });
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              controller: _controller,
              onChanged: _onChanged,
              onClear: _clear,
              onBack: () => context.pop(),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        period: const Duration(milliseconds: 1200),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 8.h),
          itemCount: 4,
          itemBuilder: (_, _) => const PostCardShimmer(),
        ),
      );
    }
    if (!_hasSearched) return const _EmptyPrompt();
    if (_results.isEmpty) return _NoResults(query: _controller.text);
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemCount: _results.length,
      itemBuilder: (_, i) => PostCard(post: _results[i]),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onBack;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: SvgPicture.asset(
                'assets/icons/icons/back_arrow.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search posts...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.sp,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.filterInactiveBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                isDense: true,
                suffixIcon: controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: onClear,
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: SvgPicture.asset('assets/icons/icons/close.svg', width: 16, height: 16, colorFilter: const ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/icons/search.svg', width: 48, height: 48, colorFilter: const ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
          SizedBox(height: 12.h),
          Text(
            'Search your campus posts',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Find posts by title or content',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/icons/search.svg', width: 48, height: 48, colorFilter: const ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
          SizedBox(height: 12.h),
          Text(
            'No results for "$query"',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Try a different keyword',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
