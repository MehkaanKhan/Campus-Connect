import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/project_partners_provider.dart';

class ProjectFilterChips extends StatelessWidget {
  const ProjectFilterChips({super.key});

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
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.filterActiveBg : AppColors.filterInactiveBg,
                border: Border.all(
                  color: isActive ? Colors.transparent : AppColors.filterInactiveBorder,
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                chip,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13.sp,
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
