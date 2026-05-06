import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_feed_usecase.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  final GetFeedUsecase _getFeedUsecase;

  FeedProvider({required GetFeedUsecase getFeedUsecase})
      : _getFeedUsecase = getFeedUsecase;

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
      _posts[idx] = post.copyWith(isUpvoted: false, upvotes: post.upvotes - 1);
    } else {
      _posts[idx] = post.copyWith(
        isUpvoted: true,
        upvotes: post.upvotes + 1,
        isDownvoted: false,
        downvotes: post.isDownvoted ? post.downvotes - 1 : post.downvotes,
      );
    }
    notifyListeners();
  }

  void toggleDownvote(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    final post = _posts[idx];
    if (post.isDownvoted) {
      _posts[idx] = post.copyWith(isDownvoted: false, downvotes: post.downvotes - 1);
    } else {
      _posts[idx] = post.copyWith(
        isDownvoted: true,
        downvotes: post.downvotes + 1,
        isUpvoted: false,
        upvotes: post.isUpvoted ? post.upvotes - 1 : post.upvotes,
      );
    }
    notifyListeners();
  }
}
