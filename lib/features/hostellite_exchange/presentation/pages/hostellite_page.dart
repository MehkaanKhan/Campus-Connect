import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/hostellite_provider.dart';
import '../widgets/hostellite_header.dart';
import '../widgets/hostellite_filter_row.dart';
import '../widgets/hostellite_items_list.dart';

class HostellitePage extends StatefulWidget {
  const HostellitePage({super.key});

  @override
  State<HostellitePage> createState() => _HostellitePageState();
}

class _HostellitePageState extends State<HostellitePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HostelliteProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altPageBg,
      body: Column(
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
          ),
          const HostelliteHeader(),
          const HostelliteFilterRow(),
          const Expanded(child: HostelliteItemsList()),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}
