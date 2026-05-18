import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/carpool_provider.dart';
import 'carpool_ride_card.dart';

class CarpoolRideList extends StatelessWidget {
  const CarpoolRideList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarpoolProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.status == CarpoolStatus.error) {
      return Center(child: Text(provider.error ?? 'Error loading rides'));
    }
    final rides = provider.filtered;
    if (rides.isEmpty) {
      return Center(
        child: Text(
          'No rides in this category',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            color: AppColors.textMuted,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      itemCount: rides.length,
      separatorBuilder: (_, _) => SizedBox(height: 14.h),
      itemBuilder: (ctx, i) => CarpoolRideCard(ride: rides[i]),
    );
  }
}
