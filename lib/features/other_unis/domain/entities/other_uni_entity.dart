class OtherUniEntity {
  final String id;
  final String name;
  final String region;
  final int memberCount;
  final int activityScore;
  final String logoText;
  final String description;
  final String? imageUrl;

  OtherUniEntity({
    required this.id,
    required this.name,
    required this.region,
    required this.memberCount,
    required this.activityScore,
    required this.logoText,
    required this.description,
    this.imageUrl,
  });

  OtherUniEntity copyWith({
    String? id,
    String? name,
    String? region,
    int? memberCount,
    int? activityScore,
    String? logoText,
    String? description,
    String? imageUrl,
  }) => OtherUniEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    region: region ?? this.region,
    memberCount: memberCount ?? this.memberCount,
    activityScore: activityScore ?? this.activityScore,
    logoText: logoText ?? this.logoText,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}
