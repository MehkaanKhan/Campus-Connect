import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/other_uni_entity.dart';
import '../provider/other_unis_provider.dart';

class OtherUnisPage extends StatefulWidget {
  const OtherUnisPage({super.key});

  @override
  State<OtherUnisPage> createState() => _OtherUnisPageState();
}

class _OtherUnisPageState extends State<OtherUnisPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtherUnisProvider>().loadUnis();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUniOverlay(BuildContext context, OtherUniEntity uni) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, secondAnim, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        );
      },
      pageBuilder: (ctx, anim, secondAnim) {
        return _UniOverlayModal(uni: uni);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CampusTopNavBar(
          onBack: context.canPop() ? () => context.pop() : null,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Other Universities',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (val) => context.read<OtherUnisProvider>().search(val),
                  decoration: InputDecoration(
                    hintText: 'Search by name or region...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OtherUnisProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: AppLoader());
                }

                if (provider.unis.isEmpty) {
                  return const Center(
                    child: Text(
                      'No universities found.',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.unis.length,
                  itemBuilder: (context, index) {
                    final uni = provider.unis[index];
                    return GestureDetector(
                      onTap: () => _showUniOverlay(context, uni),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'uni_logo_${uni.id}',
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(
                                  uni.logoText,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              uni.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              uni.region,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.people, size: 14, color: AppColors.secondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${uni.memberCount}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modal overlay – matches Figma CSS specs exactly
// ─────────────────────────────────────────────────────────────────────────────
class _UniOverlayModal extends StatelessWidget {
  final OtherUniEntity uni;

  const _UniOverlayModal({required this.uni});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // ── Blurred background ──────────────────────────────────────────
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: const Color(0xFFF2F2EF).withValues(alpha: 0.6),
                ),
              ),
            ),
          ),

          // ── Centered modal card ─────────────────────────────────────────
          Center(
            child: Container(
              width: 358,
              constraints: const BoxConstraints(maxWidth: 448),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFC3C8BC)),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 50,
                    spreadRadius: -12,
                    offset: const Offset(0, 25),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── University icon ─────────────────────────────────────
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEBEBE8),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.account_balance_rounded,
                        size: 28,
                        color: Color(0xFF98A895),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── University name ─────────────────────────────────────
                  Text(
                    uni.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      height: 32 / 24,
                      color: Color(0xFF1A1C19),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Description ─────────────────────────────────────────
                  Text(
                    uni.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                      color: Color(0xFF434940),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Member stats ────────────────────────────────────────
                  Text(
                    '${uni.memberCount} members · ${uni.region}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 24 / 16,
                      color: Color(0xFF1A1C19),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Explore button ──────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/other-unis/profile', extra: uni);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18181B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.open_in_new_rounded, size: 13.33, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Explore University',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 24 / 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
