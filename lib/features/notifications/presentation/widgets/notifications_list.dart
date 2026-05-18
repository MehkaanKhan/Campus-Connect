import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/notifications_provider.dart';
import 'notification_tile.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    if (provider.isLoading) return const AppLoader();
    final items = provider.filtered;
    if (items.isEmpty) {
      return Center(
        child: Text('No notifications', style: TextStyle(color: AppColors.textMuted, fontSize: 13.sp)),
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
