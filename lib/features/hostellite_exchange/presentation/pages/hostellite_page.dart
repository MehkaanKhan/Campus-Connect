import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/hostellite_provider.dart';
import '../widgets/hostellite_header.dart';
import '../widgets/hostellite_filter_row.dart';
import '../widgets/hostellite_items_list.dart';
import '../widgets/list_item_bottom_sheet.dart';

class HostellitePage extends StatefulWidget {
  const HostellitePage({super.key});

  @override
  State<HostellitePage> createState() => _HostellitePageState();
}

class _HostellitePageState extends State<HostellitePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HostelliteProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.altPageBg,
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.explore),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ListItemBottomSheet.show(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'List Item',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          CampusTopNavBar(
            onBack: context.canPop() ? () => context.pop() : null,
            trailing: const SizedBox.shrink(),
          ),
          const HostelliteHeader(),
          Container(
            color: AppColors.cardBg,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => context.read<HostelliteProvider>().search(val),
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Padding(padding: const EdgeInsets.all(10), child: SvgPicture.asset(AppAssets.iconSearch, width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn))),
                filled: true,
                fillColor: AppColors.filterInactiveBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const HostelliteFilterRow(),
          const Expanded(child: HostelliteItemsList()),
        ],
      ),
    );
  }
}
