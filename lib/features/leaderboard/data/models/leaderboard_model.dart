import '../../domain/entities/leaderboard_entity.dart';

class LeaderboardModel extends LeaderboardEntity {
  LeaderboardModel({
    required super.id,
    required super.name,
    required super.department,
    required super.score,
    required super.avatarUrl,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) => LeaderboardModel(
        id: json['id'] as String,
        name: json['name'] as String,
        department: json['department'] as String,
        score: json['score'] as int,
        avatarUrl: json['avatar_url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'department': department,
        'score': score,
        'avatar_url': avatarUrl,
      };
}
