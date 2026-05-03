import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/thread_provider.dart';
import '../../domain/entities/thread_entity.dart';

// ─────────────────────────────────────────────────────────
// Design colours (Thread.png)
// Scaffold bg   : #1A1A1A  dark near-black
// Content bg    : white
// Header avatar : #2C3E35  dark teal
// Meta text     : #888880  grey
// Discussion bar: #F5F5F0  warm off-white separator
// Toggle active : #6B8F6B  sage green
// Reply indent  : #F8F8F5  very light off-white card
// OP badge      : #6B8F6B green pill
// Upvote        : grey with dark text
// Negative vote : reddish text
// Comment input : white bar, green POST button
// Bottom nav    : white, sage green active
// ─────────────────────────────────────────────────────────

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThreadProvider>();
    final thread = provider.thread;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top nav bar ──
            _TopBar(),

            // ── Scrollable thread content ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Thread post body
                  _ThreadPost(thread: thread),

                  // Discussion / moderation bar
                  _DiscussionBar(
                    commentCount: thread.commentCount,
                    allowReplies: provider.allowReplies,
                    onToggle: provider.toggleReplies,
                  ),

                  // Comment list
                  ...thread.comments.map(
                    (c) => _CommentTile(comment: c, isNested: false),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── Sticky comment input + bottom nav ──
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CommentInputBar(
            controller: _commentController,
            provider: provider,
          ),
          _BottomNavBar(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Top navigation bar
// ─────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        children: [
          // Logo pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0EC),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B8F6B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded,
                      size: 11, color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Campus Connect',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, size: 24, color: Color(0xFF444440)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Thread post header + body
// ─────────────────────────────────────────────────────────
class _ThreadPost extends StatelessWidget {
  final ThreadEntity thread;
  const _ThreadPost({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar + title + meta ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3E35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    color: Colors.white54, size: 24),
              ),
              const SizedBox(width: 12),

              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.title,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'POSTED BY ${thread.authorName.toUpperCase()} • ${thread.postedAgo}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: Color(0xFF999990),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Post body ──
          Text(
            thread.body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF333330),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Discussion / moderation bar
// ─────────────────────────────────────────────────────────
class _DiscussionBar extends StatelessWidget {
  final int commentCount;
  final bool allowReplies;
  final ValueChanged<bool> onToggle;

  const _DiscussionBar({
    required this.commentCount,
    required this.allowReplies,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          // Left: Discussion count
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF1A1A1A)),
              children: [
                TextSpan(
                  text: 'Discussion ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '($commentCount\nComments)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666660),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Right: MOD toggle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'MOD: ALLOW\nREPLIES',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF999990),
                ),
              ),
              const SizedBox(height: 4),
              Transform.scale(
                scale: 0.82,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: allowReplies,
                  onChanged: onToggle,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6B8F6B),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFCCCCC8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Comment tile (handles both top-level and nested)
// ─────────────────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final CommentEntity comment;
  final bool isNested;

  const _CommentTile({required this.comment, required this.isNested});

  @override
  Widget build(BuildContext context) {
    final upvoteColor = comment.upvotes < 0
        ? const Color(0xFFB85050)
        : const Color(0xFF444440);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Comment card ──
        Container(
          margin: EdgeInsets.fromLTRB(
            isNested ? 32 : 16, // indent nested comments
            6,
            16,
            0,
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: isNested
                ? const Color(0xFFF8F8F5)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFEAEAE4),
              width: 1,
            ),
            boxShadow: isNested
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Author row ──
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isNested
                          ? const Color(0xFF3C5A8A)
                          : const Color(0xFF6B5A8A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white60, size: 16),
                  ),
                  const SizedBox(width: 8),

                  // Name
                  Text(
                    comment.authorName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  // OP badge
                  if (comment.isOp) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B8F6B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(width: 6),
                  Text(
                    comment.timeAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF999990),
                    ),
                  ),
                  const Spacer(),

                  // ── Upvote count ──
                  Row(
                    children: [
                      Icon(Icons.keyboard_arrow_up_rounded,
                          size: 16, color: upvoteColor),
                      Text(
                        '${comment.upvotes}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: upvoteColor,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: 14, color: const Color(0xFFAAAAAA)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ── Comment body ──
              Text(
                comment.content,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: Color(0xFF333330),
                ),
              ),

              const SizedBox(height: 8),

              // ── Reply button ──
              Row(
                children: [
                  const Icon(Icons.subdirectory_arrow_right_rounded,
                      size: 13, color: Color(0xFF999990)),
                  const SizedBox(width: 3),
                  const Text(
                    'REPLY',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xFF888880),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Nested replies ──
        if (comment.replies.isNotEmpty)
          ...comment.replies.map(
            (r) => _CommentTile(comment: r, isNested: true),
          ),

        const SizedBox(height: 4),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Comment input bar (sticky above bottom nav)
// ─────────────────────────────────────────────────────────
class _CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final ThreadProvider provider;

  const _CommentInputBar({
    required this.controller,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          // ── Input field ──
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: provider.setCommentDraft,
              style: const TextStyle(
                  fontSize: 14, color: Color(0xFF1A1A1A)),
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F0),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(
                      color: Color(0xFF6B8F6B), width: 1.2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // ── POST button ──
          GestureDetector(
            onTap: () async {
              await provider.submitComment();
              controller.clear();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF6B8F6B),
                borderRadius: BorderRadius.circular(100),
              ),
              child: provider.status == ThreadStatus.loading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'POST',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.play_arrow_rounded,
                            size: 16, color: Colors.white),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Bottom navigation bar
// ─────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Color(0xFFEEEEE8), width: 1)),
      ),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
                icon: Icons.home_outlined,
                label: 'HOME',
                isActive: true,
                onTap: () => context.go('/thread')),
            _NavItem(
                icon: Icons.explore_outlined,
                label: 'EXPLORE',
                isActive: false,
                onTap: () => context.go('/project-partners')),
            _NavItem(
                icon: Icons.add_circle_outline,
                label: 'CREATE',
                isActive: false,
                onTap: () => context.go('/create-post')),
            _NavItem(
                icon: Icons.notifications_none_rounded,
                label: 'ALERTS',
                isActive: false,
                onTap: () {}),
            _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'PROFILE',
                isActive: false,
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? const Color(0xFF6B8F6B) : const Color(0xFF999990);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
