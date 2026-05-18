import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../domain/entities/exchange_item_entity.dart';

class HostelliteItemCard extends StatelessWidget {
  final ExchangeItemEntity item;
  const HostelliteItemCard({super.key, required this.item});

  Color get _badgeBg {
    switch (item.type) {
      case ItemType.borrow: return AppColors.borrowBadgeBg;
      case ItemType.rent:   return AppColors.rentBadgeBg;
      case ItemType.free:   return AppColors.freeBadgeBg;
    }
  }

  Color get _badgeText {
    switch (item.type) {
      case ItemType.borrow: return AppColors.borrowBadgeText;
      case ItemType.rent:   return AppColors.rentBadgeText;
      case ItemType.free:   return AppColors.freeBadgeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hostellite-exchange/detail', extra: item),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                item.imageUrl != null
                    ? item.imageUrl!.startsWith('http')
                        ? Image.network(
                            item.imageUrl!,
                            width: double.infinity,
                            height: 170.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        : Image.asset(
                            item.imageUrl!,
                            width: double.infinity,
                            height: 170.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                    : _placeholder(),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: _badgeBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      item.typeLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: _badgeText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 11.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          item.sellerName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        item.sellerName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: double.infinity,
        height: 170.h,
        color: AppColors.borderLight,
        child: Icon(Icons.image_outlined, size: 40.w, color: AppColors.imagePlaceholder),
      );
}
