class UserProfileEntity {
  final String id;
  final String name;
  final String department;
  final String year;
  final String bio;
  final String? avatarUrl;
  final int postCount;
  final int karma;
  final int ridesCount;
  final List<ProfilePostEntity> posts;
  final List<ProfilePostEntity> reactedPosts;
  final List<String> joinedCarpools;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.department,
    required this.year,
    required this.bio,
    this.avatarUrl,
    required this.postCount,
    required this.karma,
    required this.ridesCount,
    required this.posts,
    required this.reactedPosts,
    required this.joinedCarpools,
  });
}

class ProfilePostEntity {
  final String id;
  final String flair;
  final String flairColor;
  final String title;
  final String excerpt;
  final int upvotes;
  final int commentCount;
  final String timeAgo;

  const ProfilePostEntity({
    required this.id,
    required this.flair,
    required this.flairColor,
    required this.title,
    required this.excerpt,
    required this.upvotes,
    required this.commentCount,
    required this.timeAgo,
  });
}
