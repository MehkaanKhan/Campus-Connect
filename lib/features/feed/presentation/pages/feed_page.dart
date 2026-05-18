import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../provider/feed_provider.dart';
import '../widgets/feed_header.dart';
import '../widgets/feed_body.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().loadFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: const Column(
        children: [
          CampusTopNavBar(),
          FeedHeader(),
          Expanded(child: FeedBody()),
          CampusBottomNavBar(activeTab: BottomNavTab.home),
        ],
      ),
    );
  }
}
