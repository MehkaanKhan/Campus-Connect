import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/project_partner_entity.dart';
import 'apply_bottom_sheet.dart';
import 'applications_list_sheet.dart';

class ProjectCard extends StatelessWidget {
  final ProjectPartnerEntity project;
  const ProjectCard({super.key, required this.project});

  Color _badgeTextColor() {
    switch (project.badge) {
      case 'STARTUP IDEA': return AppColors.badgeStartupText;
      case 'HACKATHON':    return AppColors.badgeHackathonText;
      default:             return AppColors.sage;
    }
  }

  Color _badgeBgColor() {
    switch (project.badge) {
      case 'STARTUP IDEA': return AppColors.badgeStartupBg;
      case 'HACKATHON':    return AppColors.badgeHackathonBg;
      default:             return AppColors.badgeDefaultBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = project.creatorId == SupabaseService.uid;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border, width: 1),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _badgeBgColor(),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  project.badge,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: _badgeTextColor(),
                  ),
                ),
              ),
              const Spacer(),
              SvgPicture.asset(AppAssets.iconBookmark, width: 20.w, height: 20.w, colorFilter: ColorFilter.mode(AppColors.navInactive, BlendMode.srcIn)),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            project.title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            project.description,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: AppColors.textCaption,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'SKILLS NEEDED',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.navInactive,
            ),
          ),
          SizedBox(height: 7.h),
          Wrap(
            spacing: 7.w,
            runSpacing: 7.h,
            children: project.skills.asMap().entries.map((entry) {
              final colors = AppColors.flairColors;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: colors[entry.key % colors.length],
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textCaption,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
          if (isOwner)
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ApplicationsListSheet(
                      listingId: project.id,
                      projectTitle: project.title,
                    ),
                  );
                },
                child: Text('View Applications (${project.applicationCount})', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else if (project.currentUserApplicationStatus == null)
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ApplyBottomSheet(
                      listingId: project.id,
                      projectTitle: project.title,
                    ),
                  );
                },
                child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.pageBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      project.currentUserApplicationStatus == 'accepted'
                          ? AppAssets.iconCheckCircle
                          : project.currentUserApplicationStatus == 'rejected'
                              ? AppAssets.iconCancelCircle
                              : AppAssets.iconClock,
                      width: 18.w,
                      height: 18.w,
                      colorFilter: ColorFilter.mode(
                        project.currentUserApplicationStatus == 'accepted'
                            ? AppColors.sage
                            : project.currentUserApplicationStatus == 'rejected'
                                ? AppColors.error
                                : AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Application ${project.currentUserApplicationStatus!.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: project.currentUserApplicationStatus == 'accepted'
                            ? AppColors.sage
                            : project.currentUserApplicationStatus == 'rejected'
                                ? AppColors.error
                                : AppColors.textSecondary,
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
