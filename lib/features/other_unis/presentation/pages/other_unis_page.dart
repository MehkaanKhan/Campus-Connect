import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../provider/other_unis_provider.dart';
import '../widgets/uni_overlay_modal.dart';
import '../widgets/other_unis_shimmer.dart';

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

  void _showUniOverlay(BuildContext context, uni) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (ctx, anim, secondAnim, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, anim, secondAnim) => UniOverlayModal(uni: uni),
    );
  }

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
          // ── Header + search ─────────────────────────────────────────
          Container(
            color: AppColors.cardBg,
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Other Universities',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Browse and explore campus communities from other universities.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: _searchController,
                  onChanged: (val) =>
                      context.read<OtherUnisProvider>().search(val),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by name or region…',
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('assets/icons/icons/search.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.close_rounded,
                                color: AppColors.textMuted, size: 18.w),
                            onPressed: () {
                              _searchController.clear();
                              context.read<OtherUnisProvider>().search('');
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.filterInactiveBg,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          const BorderSide(color: AppColors.filterInactiveBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Grid ────────────────────────────────────────────────────
          Expanded(
            child: Consumer<OtherUnisProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) return const OtherUnisShimmer();

                if (provider.error != null) {
                  return _ErrorState(
                    message: provider.error!,
                    onRetry: () => provider.loadUnis(),
                  );
                }

                if (provider.unis.isEmpty) {
                  return _EmptyState(
                    isSearch: _searchController.text.isNotEmpty,
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Fixed height per cell avoids aspect-ratio breakage
                    // when names wrap to 2 lines
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: provider.unis.length,
                  itemBuilder: (context, index) {
                    final uni = provider.unis[index];
                    return _UniCard(
                      uni: uni,
                      onTap: () => _showUniOverlay(context, uni),
                    );
                  },
                );
              },
            ),
          ),

          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Uni grid card
// ─────────────────────────────────────────────────────────────────────────────
class _UniCard extends StatelessWidget {
  final dynamic uni;
  final VoidCallback onTap;
  const _UniCard({required this.uni, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Use Padding+Column with Spacer so that variable-height
        // name text never causes the badge to overflow the cell.
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar – fixed height
              Hero(
                tag: 'uni_logo_${uni.id}',
                child: Container(
                  width: 54.w,
                  height: 54.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      uni.logoText,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Name – up to 2 lines, constrained, never grows card
              Text(
                uni.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              // Region – single line
              Text(
                uni.region,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                ),
              ),
              // Push badge to bottom regardless of name height
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_rounded,
                        size: 12.w, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      '${uni.memberCount}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isSearch;
  const _EmptyState({required this.isSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearch
                  ? Icons.search_off_rounded
                  : Icons.account_balance_outlined,
              size: 52.w,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 16.h),
            Text(
              isSearch ? 'No universities match your search.' : 'No universities found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
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
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48.w, color: AppColors.textMuted),
            SizedBox(height: 14.h),
            Text(
              'Could not load universities.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: AppColors.textMuted,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
