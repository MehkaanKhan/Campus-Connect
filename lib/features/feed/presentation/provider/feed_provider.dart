import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/vote_on_post_usecase.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final GetFeedUsecase _getFeedUsecase;
  final VoteOnPostUsecase _voteUsecase;

  FeedProvider({
    required GetFeedUsecase getFeedUsecase,
    required VoteOnPostUsecase voteUsecase,
  })  : _getFeedUsecase = getFeedUsecase,
        _voteUsecase = voteUsecase;

  FeedStatus _status = FeedStatus.initial;
  List<PostEntity> _posts = [];
  String? _error;

  FeedStatus get status => _status;
  List<PostEntity> get posts => _posts;
  String? get error => _error;
  bool get isLoading => _status == FeedStatus.loading;

  Future<void> loadFeed() async {
    _status = FeedStatus.loading;
    notifyListeners();
    try {
      _posts = await _getFeedUsecase();
      _status = FeedStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = FeedStatus.error;
    }
    notifyListeners();
  }

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
}
