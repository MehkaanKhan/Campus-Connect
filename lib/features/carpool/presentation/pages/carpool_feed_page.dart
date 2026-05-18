import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/carpool_provider.dart';
import '../widgets/carpool_filter_row.dart';
import '../widgets/carpool_divider_line.dart';
import '../widgets/carpool_ride_list.dart';

class CarpoolFeedPage extends StatefulWidget {
  const CarpoolFeedPage({super.key});

  @override
  State<CarpoolFeedPage> createState() => _CarpoolFeedPageState();
}

class _CarpoolFeedPageState extends State<CarpoolFeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarpoolProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => Navigator.of(context).pop()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColors.cardBg,
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
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
                      SizedBox(height: 14.h),
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
