import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import 'carpool_route_visual.dart';
import 'carpool_seat_row.dart';
import 'carpool_join_button.dart';

class CarpoolRideCard extends StatelessWidget {
  final CarpoolRideEntity ride;
  const CarpoolRideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ride.from} to ${ride.to}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 13.w, color: AppColors.textMuted),
                          SizedBox(width: 4.w),
                          Text(
                            '${ride.time} ${ride.date}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.sage,
                  backgroundImage: ride.driverAvatarUrl != null
                      ? NetworkImage(ride.driverAvatarUrl!)
                      : null,
                  child: ride.driverAvatarUrl == null
                      ? Text(
                          ride.driverName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          CarpoolRouteVisual(ride: ride),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CarpoolSeatRow(ride: ride),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: CarpoolJoinButton(ride: ride),
          ),
        ],
      ),
    );
  }
}
