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

  UserProfileEntity copyWith({
    String? id,
    String? name,
    String? department,
    String? year,
    String? bio,
    String? avatarUrl,
    int? postCount,
    int? karma,
    int? ridesCount,
    List<ProfilePostEntity>? posts,
    List<ProfilePostEntity>? reactedPosts,
    List<String>? joinedCarpools,
  }) => UserProfileEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    department: department ?? this.department,
    year: year ?? this.year,
    bio: bio ?? this.bio,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    postCount: postCount ?? this.postCount,
    karma: karma ?? this.karma,
    ridesCount: ridesCount ?? this.ridesCount,
    posts: posts ?? this.posts,
    reactedPosts: reactedPosts ?? this.reactedPosts,
    joinedCarpools: joinedCarpools ?? this.joinedCarpools,
  );
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

  ProfilePostEntity copyWith({
    String? id,
    String? flair,
    String? flairColor,
    String? title,
    String? excerpt,
    int? upvotes,
    int? commentCount,
    String? timeAgo,
  }) => ProfilePostEntity(
    id: id ?? this.id,
    flair: flair ?? this.flair,
    flairColor: flairColor ?? this.flairColor,
    title: title ?? this.title,
    excerpt: excerpt ?? this.excerpt,
    upvotes: upvotes ?? this.upvotes,
    commentCount: commentCount ?? this.commentCount,
    timeAgo: timeAgo ?? this.timeAgo,
  );
}
