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
    _thread = getThreadUsecase();
    _allowReplies = _thread.allowReplies;
  }

  late ThreadEntity _thread;
  ThreadEntity get thread => _thread;

  late bool _allowReplies;
  bool get allowReplies => _allowReplies;

  String _commentDraft = '';
  String get commentDraft => _commentDraft;

  ThreadStatus _status = ThreadStatus.idle;
  ThreadStatus get status => _status;

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
