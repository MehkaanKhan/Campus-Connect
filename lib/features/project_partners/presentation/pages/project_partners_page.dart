import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/project_partners_provider.dart';
import '../../domain/entities/project_partner_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';

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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──
            const CampusTopNavBar(),
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
                        fontFamily: 'Inter',
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
                        fontFamily: 'Inter',
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
      // Bottom navigation bar
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.explore),
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
                    ? AppColors.filterActiveBg
                    : AppColors.filterInactiveBg,
                border: Border.all(
                  color: isActive
                      ? Colors.transparent
                      : AppColors.filterInactiveBorder,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                chip,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : AppColors.filterInactiveText,
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
              fontFamily: 'Inter',
              fontSize: 19,
              fontWeight: FontWeight.bold,
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
            children: project.skills.asMap().entries.map(
                  (entry) {
                    final colors = AppColors.flairColors;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: colors[entry.key % colors.length],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444440),
                        ),
                      ),
                    );
                  },
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

