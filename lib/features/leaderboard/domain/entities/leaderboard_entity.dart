class LeaderboardEntity {
  final String id;
  final String name;
  final String department;
  final int score;
  final String avatarUrl;

  LeaderboardEntity({
    required this.id,
    required this.name,
    required this.department,
    required this.score,
    required this.avatarUrl,
  });

  LeaderboardEntity copyWith({
    String? id,
    String? name,
    String? department,
    int? score,
    String? avatarUrl,
  }) => LeaderboardEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    department: department ?? this.department,
    score: score ?? this.score,
    avatarUrl: avatarUrl ?? this.avatarUrl,
  );
}
