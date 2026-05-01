import '../../domain/entities/thread_entity.dart';
import '../../domain/repositories/thread_repository.dart';

class ThreadLocalDataSource {
  ThreadEntity getThread() => const ThreadEntity(
        id: '1',
        title: 'Study Group for Finals',
        authorName: 'Alex M.',
        postedAgo: '2 HOURS AGO',
        body:
            'Anyone interested in forming a study group for the upcoming Bio 101 finals? I have some past papers we can review together in the library.',
        commentCount: 12,
        allowReplies: true,
        comments: [
          CommentEntity(
            id: 'c1',
            authorName: 'Sarah J.',
            timeAgo: '1h ago',
            content:
                "I'm definitely in! What day were you thinking of meeting up?",
            upvotes: 15,
            replies: [
              CommentEntity(
                id: 'c2',
                authorName: 'Mark T.',
                timeAgo: '45m ago',
                content:
                    'Thursday evening works best for me if we can get a study room.',
                upvotes: 4,
              ),
              CommentEntity(
                id: 'c3',
                authorName: 'Alex M.',
                timeAgo: '10m ago',
                content:
                    "I'll try to book Room B on the 2nd floor for Thursday at 6PM!",
                upvotes: 2,
                isOp: true,
              ),
            ],
          ),
          CommentEntity(
            id: 'c4',
            authorName: 'Emily R.',
            timeAgo: '30m ago',
            content:
                "I don't think studying in groups is helpful for Bio, it's mostly memorization anyway.",
            upvotes: -1,
          ),
        ],
      );

  Future<void> postComment(String content) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> toggleAllowReplies(bool value) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class ThreadRepositoryImpl implements ThreadRepository {
  final ThreadLocalDataSource localSource;
  const ThreadRepositoryImpl(this.localSource);

  @override
  ThreadEntity getThread() => localSource.getThread();

  @override
  Future<void> postComment(String content) =>
      localSource.postComment(content);

  @override
  Future<void> toggleAllowReplies(bool value) =>
      localSource.toggleAllowReplies(value);
}
