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
  }) {
    _loadData();
  }

  ThreadEntity? _thread;
  ThreadEntity? get thread => _thread;

  bool _allowReplies = true;
  bool get allowReplies => _allowReplies;

  String _commentDraft = '';
  String get commentDraft => _commentDraft;

  ThreadStatus _status = ThreadStatus.idle;
  ThreadStatus get status => _status;

  Future<void> _loadData() async {
    _status = ThreadStatus.loading;
    notifyListeners();
    try {
      _thread = await getThreadUsecase();
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

  void toggleReplies(bool val) {
    _allowReplies = val;
    notifyListeners();
    toggleAllowRepliesUsecase(val);
  }

  Future<void> submitComment() async {
    if (_commentDraft.trim().isEmpty) return;
    _status = ThreadStatus.loading;
    notifyListeners();
    try {
      await postCommentUsecase(_commentDraft.trim());
      _commentDraft = '';
      _status = ThreadStatus.success;
    } catch (_) {
      _status = ThreadStatus.error;
    }
    notifyListeners();
  }
}
