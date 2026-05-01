import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/create_post_provider.dart';

// ─────────────────────────────────────────────────────────
// Design reference (Create Post.png + Figma specs)
//
// Scaffold bg   : #F0F0EC  warm off-white fills the whole page
// Header        : ✕ | Create (centre) | POST black pill
// Input box     : W=Fill, H=Hug  cornerRadius=16
//                 Transparent background — matches page background
//                 padding=24, gap=16
//                 contains: avatar row + text + flair chips
// Rest of body  : plain bg colour (no widget, just empty space)
// Bottom bar    : White, cornerRadius top-left/right = 24
//                 "inverted curve" floating effect
//                 icons left  |  0/280 + circle indicator right
// ─────────────────────────────────────────────────────────

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0EC),
      body: SafeArea(
        bottom: false, // let bottom bar handle its own safe area
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            _Header(),

            // ── Main input card + Scroll area ──
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _InputCard(),
                    ),
                    const SizedBox(height: 100), // padding to ensure chips are reachable
                  ],
                ),
              ),
            ),
 
            // ── Bottom toolbar with inverted-curve top edge ──
            const _BottomToolbar(),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          // Close
          GestureDetector(
            onTap: () => context.go('/thread'),
            child: const Icon(Icons.close, size: 22, color: Color(0xFF1A1A1A)),
          ),

          // "Create" centred
          const Expanded(
            child: Center(
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),

          // POST pill
          GestureDetector(
            onTap: () async {
              await provider.submitPost();
              if (context.mounted &&
                  provider.status == CreatePostStatus.success) {
                context.go('/thread');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
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
                        letterSpacing: 0.8,
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
//  Input card — Figma: W Fill × H Hug, radius 16,
//               Transparent, padding 24, gap 16
// ─────────────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();

    return Container(
      // Transparent — matches the page background exactly
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.all(24), // padding = 24 from Figma
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Hug height
        children: [
          // gap = 16 between avatar row and chips
          _AvatarRow(provider: provider),
          const SizedBox(height: 16),
          _FlairRow(provider: provider),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Avatar + text input row
// ─────────────────────────────────────────────────────────
class _AvatarRow extends StatelessWidget {
  final CreatePostProvider provider;
  const _AvatarRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar circle
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDEDED8), width: 1.5),
            color: const Color(0xFF1A2C3D),
          ),
          child: const ClipOval(
            child: Icon(Icons.person, color: Colors.white54, size: 26),
          ),
        ),

        const SizedBox(width: 14),

        // Hint / text field
        Expanded(
          child: TextField(
            maxLines: null,
            maxLength: 280,
            onChanged: provider.setContent,
            autofocus: false,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF1A1A1A),
              height: 1.4,
              letterSpacing: -0.1,
            ),
            decoration: const InputDecoration(
              hintText: "What's happening on campus?",
              hintMaxLines: 1,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFB8B8B0),
                height: 1.35,
                letterSpacing: -0.2,
              ),
              filled: true,
              fillColor: Colors.transparent, // Explicitly transparent
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
              counterText: '',
              isDense: true,
              contentPadding: EdgeInsets.only(top: 6),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Flair chips
// ─────────────────────────────────────────────────────────
class _FlairRow extends StatelessWidget {
  final CreatePostProvider provider;
  const _FlairRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    const flairs = ['SELECT FLAIR', 'EVENT', 'MARKETPLACE'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: flairs.map((flair) {
        final isSelected = provider.selectedFlair == flair;
        final isSelector = flair == 'SELECT FLAIR';

        return GestureDetector(
          onTap: () {
            if (!isSelector) provider.setFlair(isSelected ? null : flair);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6B8F6B)
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6B8F6B)
                    : const Color(0xFFDDDDD5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelector)
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 12,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF888880),
                    ),
                  ),
                Text(
                  flair,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isSelected ? Colors.white : const Color(0xFF888880),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Bottom toolbar
//  White background + inverted curve (top-left & top-right radius)
// ─────────────────────────────────────────────────────────
class _BottomToolbar extends StatelessWidget {
  const _BottomToolbar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreatePostProvider>();
    final charCount = provider.content.length;
    const maxChars = 280;
    final progress = charCount / maxChars;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // Inverted-curve / floating effect — round only top corners
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        children: [
          // Image icon
          _ToolbarIcon(icon: Icons.image_outlined, onTap: () {}),
          const SizedBox(width: 26),
          // Bar chart icon
          _ToolbarIcon(icon: Icons.bar_chart_rounded, onTap: () {}),
          const SizedBox(width: 26),
          // Location icon
          _ToolbarIcon(icon: Icons.location_on_outlined, onTap: () {}),

          const Spacer(),

          // 0/280 counter
          Text(
            '$charCount/$maxChars',
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFFAAAAAA),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 10),

          // Circular progress ring
          SizedBox(
            width: 26,
            height: 26,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 2.5,
                  color: const Color(0xFFE8E8E0),
                ),
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 2.5,
                  backgroundColor: Colors.transparent,
                  color: charCount > 260
                      ? const Color(0xFFB85050)
                      : const Color(0xFF6B8F6B),
                ),
              ],
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
      child: Icon(icon, size: 22, color: const Color(0xFF888880)),
    );
  }
}
