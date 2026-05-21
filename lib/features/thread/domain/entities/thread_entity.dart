class CommentEntity {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String timeAgo;
  final String content;
  final int upvotes;
  final bool isOp; // Original poster
  final List<CommentEntity> replies;

  const CommentEntity({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.timeAgo,
    required this.content,
    required this.upvotes,
    this.isOp = false,
    this.replies = const [],
  });
}

class ThreadEntity {
  final String id;
  final String title;
  final String authorName;
  final String? authorAvatarUrl;
  final String postedAgo;
  final String body;
  final String? imageUrl;
  final int commentCount;
  final bool allowReplies;
  final List<CommentEntity> comments;

  const ThreadEntity({
    required this.id,
    required this.title,
    required this.authorName,
    this.authorAvatarUrl,
    required this.postedAgo,
    required this.body,
    this.imageUrl,
    required this.commentCount,
    required this.allowReplies,
    required this.comments,
  });

  ThreadEntity copyWith({bool? allowReplies, int? commentCount, List<CommentEntity>? comments}) => ThreadEntity(
        id: id,
        title: title,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        postedAgo: postedAgo,
        body: body,
        imageUrl: imageUrl,
        commentCount: commentCount ?? this.commentCount,
        allowReplies: allowReplies ?? this.allowReplies,
        comments: comments ?? this.comments,
      );
}
