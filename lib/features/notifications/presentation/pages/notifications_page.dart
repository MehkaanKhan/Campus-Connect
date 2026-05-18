import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/notifications_provider.dart';
import '../widgets/notifications_header.dart';
import '../widgets/notifications_filter_row.dart';
import '../widgets/notifications_list.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: const Column(
        children: [
          CampusTopNavBar(),
          NotificationsHeader(),
          NotificationsFilterRow(),
          Expanded(child: NotificationsList()),
          CampusBottomNavBar(activeTab: BottomNavTab.alerts),
        ],
      ),
    );
  }
}
