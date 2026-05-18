import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_loader.dart';
import '../provider/feed_provider.dart';
import 'post_card.dart';

class FeedBody extends StatelessWidget {
  const FeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FeedProvider>();
    if (provider.isLoading) return const AppLoader();
    if (provider.status == FeedStatus.error) {
      return Center(child: Text(provider.error ?? 'Error loading feed'));
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      itemCount: provider.posts.length,
      itemBuilder: (ctx, i) => PostCard(post: provider.posts[i]),
    );
  }
}
