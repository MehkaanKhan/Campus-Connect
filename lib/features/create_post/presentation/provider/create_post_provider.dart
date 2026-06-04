
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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

  // Switches between text / image / poll input modes.
  void setTab(PostTab tab) {
    _activeTab = tab;
    notifyListeners();
  }

  // ── Title ──
  String _title = '';
  String get title => _title;

  // Synced from the TextEditingController listener on every keystroke.
  void setTitle(String val) {
    _title = val;
    notifyListeners();
  }

  // ── Content ──
  String _content = '';
  String get content => _content;

  // Synced from the TextEditingController listener on every keystroke.
  void setContent(String val) {
    _content = val;
    notifyListeners();
  }

  // ── Flair ──
  String? _selectedFlair;
  String? get selectedFlair => _selectedFlair;

  // Stores the selected flair chip; null means 'General' will be used at submission.
  void setFlair(String? flair) {
    _selectedFlair = flair;
    notifyListeners();
  }

  // ── Image ──
  Uint8List? _imageBytes;
  Uint8List? get imageBytes => _imageBytes;

  // Opens the device gallery and stores raw bytes for direct upload to Supabase Storage.
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageBytes = await pickedFile.readAsBytes();
      notifyListeners();
    }
  }

  // Clears the picked image so the user can remove it before submitting.
  void removeImage() {
    _imageBytes = null;
    notifyListeners();
  }

  // ── Status ──
  CreatePostStatus _status = CreatePostStatus.idle;
  CreatePostStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // True only when title is non-empty; drives the enabled state of the Post button.
  bool get isFormValid => _title.trim().isNotEmpty;

  // Resets all form state to defaults; called on page open so each session starts fresh.
  void reset() {
    _activeTab = PostTab.text;
    _title = '';
    _content = '';
    _imageBytes = null;
    _selectedFlair = null;
    _status = CreatePostStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Actions ──

  // Validates, uploads image if present, inserts the post, and returns the new postId
  // so the page can navigate directly to the thread. Returns null on failure.
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
          imageBytes: _imageBytes,
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
