import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/carpool_provider.dart';
import '../widgets/carpool_filter_row.dart';
import '../widgets/carpool_divider_line.dart';
import '../widgets/carpool_ride_list.dart';
import '../widgets/post_ride_bottom_sheet.dart';

class CarpoolFeedPage extends StatefulWidget {
  const CarpoolFeedPage({super.key});

  @override
  State<CarpoolFeedPage> createState() => _CarpoolFeedPageState();
}

class _CarpoolFeedPageState extends State<CarpoolFeedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarpoolProvider>().load();
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
      backgroundColor: AppColors.pageBg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final provider = context.read<CarpoolProvider>();
            final posted = await PostRideBottomSheet.show(context);
            if (posted && mounted) provider.load();
          },
          backgroundColor: AppColors.primary,
          icon: SvgPicture.asset(AppAssets.iconDirectionsCar, width: 24, height: 24, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          label: const Text(
            'Post a Ride',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => Navigator.of(context).pop(), trailing: const SizedBox.shrink()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.cardBg,
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carpool & Rides',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        controller: _searchController,
                        onChanged: (val) => context.read<CarpoolProvider>().search(val),
                        decoration: InputDecoration(
                          hintText: 'Search by origin or destination...',
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
                      SizedBox(height: 12.h),
                      const CarpoolFilterRow(),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
                const CarpoolDividerLine(),
                const Expanded(child: CarpoolRideList()),
              ],
            ),
          ),
          const CampusBottomNavBar(activeTab: BottomNavTab.explore),
        ],
      ),
    );
  }
}
