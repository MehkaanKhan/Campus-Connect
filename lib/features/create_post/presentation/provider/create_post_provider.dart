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

  // ── Title ──
  String _title = '';
  String get title => _title;

  void setTitle(String val) {
    _title = val;
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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isFormValid => _title.trim().isNotEmpty;

  void reset() {
    _activeTab = PostTab.text;
    _title = '';
    _content = '';
    _selectedFlair = null;
    _status = CreatePostStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Actions ──
  Future<String?> submitPost() async {
    if (!isFormValid) {
      _errorMessage = 'Please add a title to your post';
      notifyListeners();
      return null;
    }
    _status = CreatePostStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final postId = await submitPostUsecase(
        CreatePostEntity(
          title: _title.trim(),
          content: _content.trim(),
          tags: _selectedFlair != null ? [_selectedFlair!] : [],
        ),
      );
      _status = CreatePostStatus.success;
      notifyListeners();
      return postId;
    } catch (e) {
      debugPrint('SubmitPost Error: $e');
      _errorMessage = e.toString();
      _status = CreatePostStatus.error;
      notifyListeners();
      return null;
    }
  }
}
