import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/size_config.dart';
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
  final _commentFocusNode = FocusNode();

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
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _onReply(String commentId, String authorName) {
    context.read<ThreadProvider>().setReplyTarget(commentId, authorName);
    _commentFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThreadProvider>();
    final thread = provider.thread;

    return Scaffold(
      backgroundColor: AppColors.altPageBg,
      bottomNavigationBar: const CampusBottomNavBar(activeTab: BottomNavTab.home),
      bottomSheet: ThreadCommentInputBar(controller: _commentController, focusNode: _commentFocusNode),
      body: Column(
        children: [
          CampusTopNavBar(onBack: () => context.canPop() ? context.pop() : context.go('/feed')),
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
                        (c) => ThreadCommentTile(comment: c, isNested: false, onReply: _onReply),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
