import 'package:flutter/foundation.dart';
import '../../domain/entities/thread_entity.dart';
import '../../domain/usecases/thread_usecases.dart';

enum ThreadStatus { idle, loading, success, error }

class ThreadProvider extends ChangeNotifier {
  final GetThreadUsecase getThreadUsecase;
  final PostCommentUsecase postCommentUsecase;
  final ToggleAllowRepliesUsecase toggleAllowRepliesUsecase;

  ThreadProvider({
    required this.getThreadUsecase,
    required this.postCommentUsecase,
    required this.toggleAllowRepliesUsecase,
  });

  ThreadEntity? _thread;
  ThreadEntity? get thread => _thread;

  String? _activePostId;
  String? get activePostId => _activePostId;

  bool _allowReplies = true;
  bool get allowReplies => _allowReplies;

  String? _replyingToCommentId;
  String? get replyingToCommentId => _replyingToCommentId;

  String? _replyingToAuthorName;
  String? get replyingToAuthorName => _replyingToAuthorName;

  String _commentDraft = '';
  String get commentDraft => _commentDraft;

  String? _replyToId;
  String? _replyToName;
  String? get replyToId => _replyToId;
  String? get replyToName => _replyToName;

  ThreadStatus _status = ThreadStatus.idle;
  ThreadStatus get status => _status;

  Future<void> loadThread(String postId) async {
    _activePostId = postId;
    _thread = null;
    _status = ThreadStatus.loading;
    notifyListeners();
    try {
      _thread = await getThreadUsecase(postId);
      _allowReplies = _thread?.allowReplies ?? true;
      _status = ThreadStatus.success;
    } catch (_) {
      _status = ThreadStatus.error;
    }
    notifyListeners();
  }

  void setCommentDraft(String val) {
    _commentDraft = val;
    notifyListeners();
  }

  void setReplyTarget(String commentId, String authorName) {
    _replyToId = commentId;
    _replyToName = authorName;
    notifyListeners();
  }

  void clearReplyTarget() {
    _replyToId = null;
    _replyToName = null;
    notifyListeners();
  }

  Future<void> submitComment() async {
    if (_commentDraft.trim().isEmpty || _activePostId == null || _thread == null) return;

    final draft = _commentDraft.trim();
    final parentId = _replyToId;
    _commentDraft = '';
    _replyToId = null;
    _replyToName = null;

    // Optimistic update only for top-level comments
    if (parentId == null) {
      final tempComment = CommentEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'You',
        authorAvatarUrl: null,
        timeAgo: 'Just now',
        content: draft,
        upvotes: 0,
        isOp: false,
        replies: const [],
      );
      _thread = _thread!.copyWith(
        commentCount: _thread!.commentCount + 1,
        comments: [..._thread!.comments, tempComment],
      );
    }
    notifyListeners();

    try {
      await postCommentUsecase(_activePostId!, draft, parentId: parentId);
      final updatedThread = await getThreadUsecase(_activePostId!);
      _thread = updatedThread;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleReplies(bool val) async {
    if (_activePostId == null) return;
    _allowReplies = val;
    notifyListeners();
    try {
      await toggleAllowRepliesUsecase(_activePostId!, val);
    } catch (_) {
      // Revert if error
      _allowReplies = !_allowReplies;
      notifyListeners();
    }
  }
}
