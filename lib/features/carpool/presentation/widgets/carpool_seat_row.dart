import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/carpool_ride_entity.dart';

class CarpoolSeatRow extends StatelessWidget {
  final CarpoolRideEntity ride;
  const CarpoolSeatRow({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < ride.totalSeats; i++)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              i < ride.takenSeats
                  ? Icons.person_off_outlined
                  : Icons.person_outline_rounded,
              size: 20.w,
              color: i < ride.takenSeats ? AppColors.imagePlaceholder : AppColors.sage,
            ),
          ),
        SizedBox(width: 6.w),
        Text(
          '${ride.seatsAvailable} seat${ride.seatsAvailable == 1 ? '' : 's'} available',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.filterInactiveText,
          ),
        ),
      ],
    );
  }
}
