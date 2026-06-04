import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class ProfileCarpoolsList extends StatelessWidget {
  final List<String> carpools;
  const ProfileCarpoolsList({super.key, required this.carpools});

  @override
  Widget build(BuildContext context) {
    if (carpools.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Text('No carpools joined yet', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      itemCount: carpools.length,
      itemBuilder: (ctx, i) => Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.notifIconBg,
              child: SvgPicture.asset(AppAssets.iconDirectionsCar, width: 16.w, height: 16.w, colorFilter: ColorFilter.mode(AppColors.sage, BlendMode.srcIn)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                carpools[i],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
