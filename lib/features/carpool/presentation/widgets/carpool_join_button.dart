import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../provider/carpool_provider.dart';

class CarpoolJoinButton extends StatelessWidget {
  final CarpoolRideEntity ride;
  const CarpoolJoinButton({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final joined = ride.hasJoined;
    final noSeats = ride.seatsAvailable == 0;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: (joined || noSeats)
            ? null
            : () => context.read<CarpoolProvider>().joinRide(ride.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: joined
                ? AppColors.sage
                : noSeats
                    ? AppColors.border
                    : AppColors.textPrimary,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              joined ? '✓ Joined' : noSeats ? 'Fully Booked' : 'Join Ride',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: noSeats && !joined ? AppColors.textHint : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
