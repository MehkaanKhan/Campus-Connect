import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/vote_on_post_usecase.dart';
import '../../domain/usecases/get_university_name_usecase.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final GetFeedUsecase _getFeedUsecase;
  final VoteOnPostUsecase _voteUsecase;
  final GetUniversityNameUsecase _getUniversityNameUsecase;

  FeedProvider({
    required GetFeedUsecase getFeedUsecase,
    required VoteOnPostUsecase voteUsecase,
    required GetUniversityNameUsecase getUniversityNameUsecase,
  })  : _getFeedUsecase = getFeedUsecase,
        _voteUsecase = voteUsecase,
        _getUniversityNameUsecase = getUniversityNameUsecase;

  FeedStatus _status = FeedStatus.initial;
  List<PostEntity> _posts = [];
  String? _error;
  String _universityName = 'Your Campus';

  FeedStatus get status => _status;
  List<PostEntity> get posts => _posts;
  String? get error => _error;
  bool get isLoading => _status == FeedStatus.loading;
  String get universityName => _universityName;

  // Fetches the university name and posts in parallel, then updates state.
  Future<void> loadFeed() async {
    _status = FeedStatus.loading;
    notifyListeners();
    try {
      final futures = await Future.wait([
        _getUniversityNameUsecase(),
        _getFeedUsecase(),
      ]);
      _universityName = futures[0] as String;
      _posts = futures[1] as List<PostEntity>;

      _status = FeedStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = FeedStatus.error;
    }
    notifyListeners();
  }

  // Optimistically updates the post in memory, then fires the DB write async (fire-and-forget).
  // Handles 3 cases: remove existing upvote, switch from downvote, or cast a new upvote.
  void toggleUpvote(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    final post = _posts[idx];

    if (post.isUpvoted) {
      // Remove upvote
      _posts[idx] = post.copyWith(isUpvoted: false, upvotes: post.upvotes - 1);
      notifyListeners();
      _voteUsecase.delete(postId).ignore();
    } else if (post.isDownvoted) {
      // Switch from down → up
      _posts[idx] = post.copyWith(
        isUpvoted: true, upvotes: post.upvotes + 1,
        isDownvoted: false, downvotes: post.downvotes - 1,
      );
      notifyListeners();
      _voteUsecase.update(postId, 'up').ignore();
    } else {
      // New upvote
      _posts[idx] = post.copyWith(isUpvoted: true, upvotes: post.upvotes + 1);
      notifyListeners();
      _voteUsecase.insert(postId, 'up').ignore();
    }
  }

  // Mirror of toggleUpvote — same 3-case optimistic logic for downvotes.
  void toggleDownvote(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    final post = _posts[idx];

    if (post.isDownvoted) {
      // Remove downvote
      _posts[idx] = post.copyWith(isDownvoted: false, downvotes: post.downvotes - 1);
      notifyListeners();
      _voteUsecase.delete(postId).ignore();
    } else if (post.isUpvoted) {
      // Switch from up → down
      _posts[idx] = post.copyWith(
        isDownvoted: true, downvotes: post.downvotes + 1,
        isUpvoted: false, upvotes: post.upvotes - 1,
      );
      notifyListeners();
      _voteUsecase.update(postId, 'down').ignore();
    } else {
      // New downvote
      _posts[idx] = post.copyWith(isDownvoted: true, downvotes: post.downvotes + 1);
      notifyListeners();
      _voteUsecase.insert(postId, 'down').ignore();
    }
  }

  // Bumps comment count in memory when the Thread screen posts a new comment, avoiding a reload.
  void incrementCommentCount(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    final post = _posts[idx];
    _posts[idx] = post.copyWith(commentCount: post.commentCount + 1);
    notifyListeners();
  }
}
