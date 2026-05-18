import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../widgets/project_filter_chips.dart';
import '../widgets/project_list.dart';

class ProjectPartnersPage extends StatelessWidget {
  const ProjectPartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Find Project\nPartners',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Connect with peers across campus to collaborate on innovative projects, startups, and academic research.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5.sp,
                      height: 1.55,
                      color: AppColors.textFaint,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const ProjectFilterChips(),
                  SizedBox(height: 22.h),
                  const ProjectList(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.explore),
    );
  }
}
