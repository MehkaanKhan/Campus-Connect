import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../provider/notifications_provider.dart';

class NotificationsFilterRow extends StatelessWidget {
  const NotificationsFilterRow({super.key});

  static const _filters = [
    (NotificationsFilter.all, 'All'),
    (NotificationsFilter.comments, 'Comments'),
    (NotificationsFilter.carpools, 'Carpools'),
    (NotificationsFilter.posts, 'Posts'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = context.watch<NotificationsProvider>().filter;
    return Container(
      color: AppColors.cardBg,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final isActive = current == f.$1;
            return GestureDetector(
              onTap: () => context.read<NotificationsProvider>().setFilter(f.$1),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.filterActiveBg : AppColors.filterInactiveBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: isActive ? null : Border.all(color: AppColors.filterInactiveBorder),
                ),
                child: Text(
                  f.$2,
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
