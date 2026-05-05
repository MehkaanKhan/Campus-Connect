import 'package:flutter/material.dart';

class PostEntity {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String timeAgo;
  final String flair;
  final Color flairColor;
  final String title;
  final String excerpt;
  final String? imageUrl;
  final int upvotes;
  final int downvotes;
  final int commentCount;
  final bool isUpvoted;
  final bool isDownvoted;

  const PostEntity({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.timeAgo,
    required this.flair,
    required this.flairColor,
    required this.title,
    required this.excerpt,
    this.imageUrl,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    this.isUpvoted = false,
    this.isDownvoted = false,
  });

  PostEntity copyWith({bool? isUpvoted, bool? isDownvoted, int? upvotes, int? downvotes}) =>
      PostEntity(
        id: id,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        timeAgo: timeAgo,
        flair: flair,
        flairColor: flairColor,
        title: title,
        excerpt: excerpt,
        imageUrl: imageUrl,
        upvotes: upvotes ?? this.upvotes,
        downvotes: downvotes ?? this.downvotes,
        commentCount: commentCount,
        isUpvoted: isUpvoted ?? this.isUpvoted,
        isDownvoted: isDownvoted ?? this.isDownvoted,
      );
}
