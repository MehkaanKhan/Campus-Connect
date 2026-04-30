import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/create_post_provider.dart';

// ─────────────────────────────────────────────────────────
// Design colours (Create Post.png)
// Full-page bg  : #F2F2EE  warm off-white — fills entire screen
// Header row    : same bg, ✕ icon | "Create" title | POST pill
// Tab bar track : #E4E4DF, active pill = white
// POST button   : #1A1A1A pill, white text
// Flair chip    : #EBEBEB bg, #555 text, rounded
// Bottom bar    : white bg, grey icons, char counter
// ─────────────────────────────────────────────────────────

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full white-ish background — no dark scaffold visible
      backgroundColor: const Color(0xFFF2F2EE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header row (✕  Create  POST) ──
            _Header(),

            // ── Tab bar ──
            _TabBar(),

            // ── Main content (avatar + textarea) — expands to fill ──
            Expanded(child: _ContentArea()),

            // ── Flair chips ──
            _FlairRow(),

            // ── Divider ──
            const Divider(height: 1, thickness: 1, color: Color(0xFFDEDED8)),

            // ── Bottom toolbar ──
            _BottomToolbar(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Header  (✕  Create  POST)
// ─────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Row(
        children: [
          // ── Close icon ──
          GestureDetector(
            onTap: () => context.go('/project-partners'),
            child: const Icon(Icons.close, size: 22, color: Color(0xFF2A2A28)),
          ),

          // ── "Create" centred ──
          const Expanded(
            child: Center(
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),

          // ── POST pill ──
          GestureDetector(
            onTap: () async {
              await provider.submitPost();
              if (context.mounted &&
                  provider.status == CreatePostStatus.success) {
                context.go('/project-partners');
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(100),
              ),
              child: provider.status == CreatePostStatus.loading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'POST',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Tab bar  (TEXT | IMAGE | POLL)
// ─────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    const tabs = [
      (PostTab.text, 'TEXT'),
      (PostTab.image, 'IMAGE'),
      (PostTab.poll, 'POLL'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFFE4E4DF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: tabs.map((t) {
            final isActive = provider.activeTab == t.$1;
            return Expanded(
              child: GestureDetector(
                onTap: () => provider.setTab(t.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      t.$2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: isActive
                            ? const Color(0xFF1A1A1A)
                            : const Color(0xFF888880),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Content area  (avatar + text field)
// ─────────────────────────────────────────────────────────
class _ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2C3E35),
              shape: BoxShape.circle,
              border:
                  Border.all(color: const Color(0xFFD0D0C8), width: 1.5),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white54,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // ── Text input ──
          Expanded(
            child: TextField(
              maxLines: null,
              maxLength: 280,
              onChanged: provider.setContent,
              autofocus: false,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A1A1A),
                height: 1.45,
              ),
              decoration: const InputDecoration(
                hintText: "What's happening on campus?",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFAAAAAA),
                  height: 1.45,
                ),
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Flair chips row
// ─────────────────────────────────────────────────────────
class _FlairRow extends StatelessWidget {
  const _FlairRow();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();
    const flairs = ['SELECT FLAIR', 'EVENT', 'MARKETPLACE'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: flairs.map((flair) {
          final isSelected = provider.selectedFlair == flair;
          final isSelector = flair == 'SELECT FLAIR';

          return GestureDetector(
            onTap: () {
              if (!isSelector) {
                provider.setFlair(isSelected ? null : flair);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6B8F6B)
                    : const Color(0xFFEBEBE7),
                borderRadius: BorderRadius.circular(100),
                border: isSelector
                    ? Border.all(
                        color: const Color(0xFFCCCCC8), width: 1)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelector)
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.local_offer_outlined,
                        size: 12,
                        color: Color(0xFF666660),
                      ),
                    ),
                  Text(
                    flair,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF555550),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Bottom toolbar  (image | chart | location | 0/280)
// ─────────────────────────────────────────────────────────
class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();
    final charCount = provider.content.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          _ToolbarIcon(icon: Icons.image_outlined, onTap: () {}),
          const SizedBox(width: 22),
          _ToolbarIcon(icon: Icons.bar_chart_outlined, onTap: () {}),
          const SizedBox(width: 22),
          _ToolbarIcon(icon: Icons.location_on_outlined, onTap: () {}),
          const Spacer(),
          Text(
            '$charCount/280',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999990),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ToolbarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 22, color: const Color(0xFF666660)),
    );
  }
}
