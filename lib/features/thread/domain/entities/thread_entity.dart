class CommentEntity {
  final String id;
  final String authorName;
  final String timeAgo;
  final String content;
  final int upvotes;
  final bool isOp; // Original poster
  final List<CommentEntity> replies;

  const CommentEntity({
    required this.id,
    required this.authorName,
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
  final String postedAgo;
  final String body;
  final int commentCount;
  final bool allowReplies;
  final List<CommentEntity> comments;

  const ThreadEntity({
    required this.id,
    required this.title,
    required this.authorName,
    required this.postedAgo,
    required this.body,
    required this.commentCount,
    required this.allowReplies,
    required this.comments,
  });

  ThreadEntity copyWith({bool? allowReplies}) => ThreadEntity(
        id: id,
        title: title,
        authorName: authorName,
        postedAgo: postedAgo,
        body: body,
        commentCount: commentCount,
        allowReplies: allowReplies ?? this.allowReplies,
        comments: comments,
      );
}
