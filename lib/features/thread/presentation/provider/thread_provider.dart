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

  String _commentDraft = '';
  String get commentDraft => _commentDraft;

  ThreadStatus _status = ThreadStatus.idle;
  ThreadStatus get status => _status;

  Future<void> loadThread(String postId) async {
    _activePostId = postId;
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

  Future<void> submitComment() async {
    if (_commentDraft.trim().isEmpty || _activePostId == null) return;
    _status = ThreadStatus.loading;
    notifyListeners();
    try {
      await postCommentUsecase(_activePostId!, _commentDraft.trim());
      _commentDraft = '';
      _status = ThreadStatus.success;
      
      // Reload thread to show new comment
      await loadThread(_activePostId!);
    } catch (_) {
      _status = ThreadStatus.error;
    }
    notifyListeners();
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
