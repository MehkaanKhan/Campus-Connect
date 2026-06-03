import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../provider/carpool_provider.dart';
import 'carpool_ride_card.dart';
import 'carpool_ride_shimmer.dart';

class CarpoolRideList extends StatelessWidget {
  const CarpoolRideList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarpoolProvider>();
    if (provider.isLoading) return const CarpoolShimmerList();
    if (provider.status == CarpoolStatus.error) {
      return ErrorState(
        message: provider.error,
        onRetry: () => context.read<CarpoolProvider>().load(),
      );
    }
    final rides = provider.filtered;
    if (rides.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.iconDirectionsCar, width: 48.w, height: 48.w, colorFilter: ColorFilter.mode(AppColors.imagePlaceholder, BlendMode.srcIn)),
            SizedBox(height: 12.h),
            Text(
              'No rides in this category',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Post a ride to get the ball rolling.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: AppColors.textMuted),
            ),
          ],
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
