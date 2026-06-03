import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../provider/project_partners_provider.dart';
import 'project_card.dart';
import 'project_card_shimmer.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectPartnersProvider>();

    if (provider.status == ProjectPartnersStatus.loading) {
      return const ProjectShimmerList();
    }

    if (provider.status == ProjectPartnersStatus.error) {
      return ErrorState(
        message: provider.error,
        onRetry: () => context.read<ProjectPartnersProvider>().reload(),
      );
    }

    final projects = provider.filteredProjects;

    if (projects.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/icons/group_add.svg', width: 48.w, height: 48.w, colorFilter: ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
              SizedBox(height: 12.h),
              Text(
                'No projects found',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Be the first to post a project!',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: projects
          .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: ProjectCard(project: p),
              ))
          .toList(),
    );
  }
}
