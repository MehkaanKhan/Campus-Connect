import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/carpool_ride_entity.dart';
import '../provider/carpool_provider.dart';

class CarpoolFilterRow extends StatelessWidget {
  const CarpoolFilterRow({super.key});

  static const _filters = [
    (CarpoolFilter.all, 'All'),
    (CarpoolFilter.morning, 'Morning'),
    (CarpoolFilter.evening, 'Evening'),
    (CarpoolFilter.weekend, 'Weekend'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<CarpoolProvider>().filter;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((f) {
          final isActive = current == f.$1;
          return GestureDetector(
            onTap: () => context.read<CarpoolProvider>().setFilter(f.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8.w, bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.sage : AppColors.cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive ? AppColors.sage : AppColors.filterInactiveBorder,
                ),
              ),
              child: Text(
                f.$2,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.filterInactiveText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
