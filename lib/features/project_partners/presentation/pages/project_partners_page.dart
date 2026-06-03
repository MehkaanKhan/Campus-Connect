import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../provider/project_partners_provider.dart';
import '../widgets/project_filter_chips.dart';
import '../widgets/project_list.dart';
import '../widgets/create_project_bottom_sheet.dart';

class ProjectPartnersPage extends StatefulWidget {
  const ProjectPartnersPage({super.key});

  @override
  State<ProjectPartnersPage> createState() => _ProjectPartnersPageState();
}

class _ProjectPartnersPageState extends State<ProjectPartnersPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ProjectPartnersProvider>().loadMoreProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                  SizedBox(height: 5.h),
                  Text(
                    'lISting: ${context.watch<ProjectPartnersProvider>().allProjects.length}',
                    
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
                  SizedBox(height: 24.h),
                  
                  // Twitter-style project detail sharing bar
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.sageLight,
                          ),
                          child: const Icon(
                            Icons.group_add_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: AppColors.transparent,
                                builder: (context) => const CreateProjectBottomSheet(),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                              decoration: BoxDecoration(
                                color: AppColors.pageBg,
                                borderRadius: BorderRadius.circular(100.r),
                                border: Border.all(color: AppColors.border, width: 1),
                              ),
                              child: Text(
                                'Looking for a partner? Share your project...',
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  const ProjectFilterChips(),
                  SizedBox(height: 22.h),
                  const ProjectList(),
                  Consumer<ProjectPartnersProvider>(
                    builder: (context, provider, child) {
                      if (provider.isFetchingMore) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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
