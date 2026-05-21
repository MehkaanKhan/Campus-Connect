import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/campus_top_navbar.dart';
import '../../../../core/widgets/campus_bottom_navbar.dart';
import '../provider/thread_provider.dart';
import '../widgets/thread_post.dart';
import '../widgets/thread_discussion_bar.dart';
import '../widgets/thread_comment_tile.dart';
import '../widgets/thread_comment_input_bar.dart';

class ThreadPage extends StatefulWidget {
  final String postId;
  const ThreadPage({super.key, required this.postId});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.postId.isNotEmpty) {
        context.read<ThreadProvider>().loadThread(widget.postId);
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThreadProvider>();
    final thread = provider.thread;

    return Scaffold(
      backgroundColor: AppColors.altPageBg,
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.home),
      bottomSheet: ThreadCommentInputBar(controller: _commentController),
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => context.go('/feed')),
          Expanded(
            child: thread == null
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ThreadPost(thread: thread),
                      ThreadDiscussionBar(
                        commentCount: thread.commentCount,
                        allowReplies: provider.allowReplies,
                        onToggle: provider.toggleReplies,
                      ),
                      ...thread.comments.map(
                        (c) => ThreadCommentTile(comment: c, isNested: false),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
