import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/exchange_item_entity.dart';
import '../provider/hostellite_provider.dart';

class HostelliteFilterRow extends StatelessWidget {
  const HostelliteFilterRow({super.key});

  static const _options = [
    (null, 'All Items'),
    (ItemType.borrow, 'BORROW'),
    (ItemType.rent, 'RENT'),
    (ItemType.free, 'Free'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<HostelliteProvider>().filter;
    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _options.map((opt) {
            final isActive = current == opt.$1;
            return GestureDetector(
              onTap: () => context.read<HostelliteProvider>().setFilter(opt.$1),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.filterActiveBg : AppColors.filterInactiveBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: isActive ? null : Border.all(color: AppColors.filterInactiveBorder),
                ),
                child: Text(
                  opt.$2,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.filterInactiveText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
