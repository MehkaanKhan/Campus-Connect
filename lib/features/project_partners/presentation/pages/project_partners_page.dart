import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../provider/project_partners_provider.dart';
import '../../domain/entities/project_partner_entity.dart';

// ─────────────────────────────────────────────────────────
// Design colours (ProjectPartners.png)
// Background      : #1A1A1A  dark scaffold
// Content bg      : white (scroll area)
// Badge Academic  : #6B8F6B green text, light green bg
// Badge Startup   : #C8913A amber text, light amber bg
// Badge Hackathon : #5A7FA8 blue text, light blue bg
// Filter active   : #1A1A1A pill with white text
// Filter inactive : white pill with dark border
// Skill chip      : #F0F0EC bg, #444 text
// Bottom nav      : white bg, icons
// ─────────────────────────────────────────────────────────

class ProjectPartnersPage extends StatelessWidget {
  const ProjectPartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──
            _TopBar(),
            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Title
                    const Text(
                      'Find Project\nPartners',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    const Text(
                      'Connect with peers across campus to collaborate on innovative projects, startups, and academic research.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.55,
                        color: Color(0xFF666660),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Filter chips
                    _FilterChips(),
                    const SizedBox(height: 22),
                    // Project cards
                    _ProjectList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Top bar (Campus Connect logo + search icon)
// ─────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Row(
        children: [
          // Logo pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
//  Horizontal filter chips
// ─────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectPartnersProvider>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: provider.filterChips.map((chip) {
          final isActive = provider.selectedFilter == chip;
          return GestureDetector(
            onTap: () => provider.setFilter(chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF1A1A1A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF1A1A1A)
                      : const Color(0xFFD0D0C8),
                  width: 1.2,
                ),
              ),
              child: Text(
                chip,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF444440),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Project card list
// ─────────────────────────────────────────────────────────
class _ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectPartnersProvider>();
    final projects = provider.filteredProjects;

    return Column(
      children: projects
          .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ProjectCard(project: p),
              ))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Single project card
// ─────────────────────────────────────────────────────────
class _ProjectCard extends StatelessWidget {
  final ProjectPartnerEntity project;
  const _ProjectCard({required this.project});

  Color _badgeTextColor() {
    switch (project.badge) {
      case 'STARTUP IDEA':
        return const Color(0xFFC8913A);
      case 'HACKATHON':
        return const Color(0xFF5A7FA8);
      default:
        return const Color(0xFF6B8F6B);
    }
  }

  Color _badgeBgColor() {
    switch (project.badge) {
      case 'STARTUP IDEA':
        return const Color(0xFFFDF3E6);
      case 'HACKATHON':
        return const Color(0xFFEAF1F8);
      default:
        return const Color(0xFFEDF4ED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAE4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Badge + bookmark ──
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeBgColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  project.badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: _badgeTextColor(),
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.bookmark_border_rounded,
                  size: 20, color: Color(0xFF999990)),
            ],
          ),
          const SizedBox(height: 10),

          // ── Title ──
          Text(
            project.title,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 19,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),

          // ── Description ──
          Text(
            project.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF555550),
            ),
          ),
          const SizedBox(height: 14),

          // ── Skills label ──
          const Text(
            'SKILLS NEEDED',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF999990),
            ),
          ),
          const SizedBox(height: 7),

          // ── Skill chips ──
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: project.skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0EC),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF444440),
                      ),
                    ),
                  ),
                )
                .toList(),
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
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEE8), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'HOME', isActive: false,
              onTap: () => context.go('/thread')),
          _NavItem(icon: Icons.explore_outlined, label: 'EXPLORE', isActive: true,
              onTap: () => context.go('/project-partners')),
          _NavItem(icon: Icons.add_circle_outline, label: 'CREATE', isActive: false,
              onTap: () => context.go('/create-post')),
          _NavItem(icon: Icons.notifications_none_rounded, label: 'ALERTS',
              isActive: false, onTap: () {}),
          _NavItem(icon: Icons.person_outline_rounded, label: 'PROFILE',
              isActive: false, onTap: () {}),
        ],
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
