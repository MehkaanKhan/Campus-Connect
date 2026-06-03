import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../provider/notifications_provider.dart';
import 'notification_tile.dart';
import 'notification_tile_shimmer.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    if (provider.isLoading) return const NotificationsShimmerList();
    if (provider.status == NotificationsStatus.error) {
      return ErrorState(
        message: provider.error,
        onRetry: () => context.read<NotificationsProvider>().load(),
      );
    }
    final items = provider.filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off_outlined, size: 48.w, color: AppColors.imagePlaceholder),
            SizedBox(height: 12.h),
            Text(
              'All caught up!',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'No notifications here yet.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 13.sp, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: items.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: AppColors.border),
      itemBuilder: (ctx, i) => NotificationTile(item: items[i]),
    );
  }
}
