import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/project_partner_entity.dart';

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
              Icon(Icons.bookmark_border_rounded, size: 20.w, color: AppColors.navInactive),
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
        ],
      ),
    );
  }
}
