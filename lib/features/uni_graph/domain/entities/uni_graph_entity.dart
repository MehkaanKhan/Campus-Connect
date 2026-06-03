class UniNodeEntity {
  final String id;
  final String name;
  final double x;
  final double y;
  final int activityLevel; // 0 to 100

  UniNodeEntity({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.activityLevel,
  });

  UniNodeEntity copyWith({
    String? id,
    String? name,
    double? x,
    double? y,
    int? activityLevel,
  }) => UniNodeEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    x: x ?? this.x,
    y: y ?? this.y,
    activityLevel: activityLevel ?? this.activityLevel,
  );
}

class UniEdgeEntity {
  final String sourceId;
  final String targetId;
  final double strength;

  UniEdgeEntity({
    required this.sourceId,
    required this.targetId,
    required this.strength,
  });

  UniEdgeEntity copyWith({
    String? sourceId,
    String? targetId,
    double? strength,
  }) => UniEdgeEntity(
    sourceId: sourceId ?? this.sourceId,
    targetId: targetId ?? this.targetId,
    strength: strength ?? this.strength,
  );
}
