import 'package:flutter/foundation.dart';
import '../../domain/usecases/submit_post_usecase.dart';
import '../../domain/entities/create_post_entity.dart';

enum PostTab { text, image, poll }

enum CreatePostStatus { idle, loading, success, error }

class CreatePostProvider extends ChangeNotifier {
  final SubmitPostUsecase submitPostUsecase;

  CreatePostProvider({required this.submitPostUsecase});

  // ── Tab ──
  PostTab _activeTab = PostTab.text;
  PostTab get activeTab => _activeTab;

  void setTab(PostTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // ── Content ──
  String _content = '';
  String get content => _content;

  void setContent(String val) {
    _content = val;
    notifyListeners();
  }

  // ── Flair ──
  String? _selectedFlair;
  String? get selectedFlair => _selectedFlair;

  void setFlair(String? flair) {
    _selectedFlair = flair;
    notifyListeners();
  }

  // ── Status ──
  CreatePostStatus _status = CreatePostStatus.idle;
  CreatePostStatus get status => _status;

  bool get isFormValid => _content.trim().isNotEmpty;

  // ── Actions ──
  Future<void> submitPost() async {
    if (!isFormValid) return;
    _status = CreatePostStatus.loading;
    notifyListeners();
    try {
      await submitPostUsecase(
        CreatePostEntity(
          title: '',
          content: _content.trim(),
          tags: _selectedFlair != null ? [_selectedFlair!] : [],
        ),
      );
      _status = CreatePostStatus.success;
    } catch (_) {
      _status = CreatePostStatus.error;
    }
    notifyListeners();
  }
}
