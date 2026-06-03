import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity item;
  const NotificationTile({super.key, required this.item});

  String get _svgAsset {
    switch (item.type) {
      case NotificationType.comment:     return AppAssets.iconReply;
      case NotificationType.carpool:     return AppAssets.iconDirectionsCar;
      case NotificationType.club:        return AppAssets.iconGroupAdd;
      case NotificationType.marketplace: return AppAssets.iconShoppingCart;
      case NotificationType.general:     return AppAssets.iconNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.isRead ? AppColors.cardBg : AppColors.unreadNotifBg,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.notifIconBg,
            child: SvgPicture.asset(_svgAsset, width: 18.w, height: 18.w, colorFilter: const ColorFilter.mode(AppColors.sage, BlendMode.srcIn)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                    fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.timeAgo,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                  ),
                ),
                if (item.hasAction) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.filterActiveBg,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.only(top: 4.h),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sage,
              ),
            ),
        ],
      ),
    );
  }
}
