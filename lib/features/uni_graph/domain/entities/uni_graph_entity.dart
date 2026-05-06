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
}
