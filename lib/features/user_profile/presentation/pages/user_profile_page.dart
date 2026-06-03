import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/user_profile_provider.dart';
import '../widgets/profile_body.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().load(SupabaseService.uid);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.profile),
      body: Column(
        children: [
          CampusTopNavBar(
            trailing: GestureDetector(
              onTap: () => context.push('/settings'),
              child: SvgPicture.asset(AppAssets.iconSettings, width: 24, height: 24, colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn)),
            ),
          ),
          Expanded(child: ProfileBody(tabController: _tabController)),
        ],
      ),
    );
  }
}
