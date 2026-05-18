import '../../domain/entities/uni_graph_entity.dart';

class UniNodeModel extends UniNodeEntity {
  UniNodeModel({
    required super.id,
    required super.name,
    required super.x,
    required super.y,
    required super.activityLevel,
  });

  factory UniNodeModel.fromJson(Map<String, dynamic> json) => UniNodeModel(
        id: json['id'] as String,
        name: json['name'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        activityLevel: json['activity_level'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'x': x,
        'y': y,
        'activity_level': activityLevel,
      };
}

class UniEdgeModel extends UniEdgeEntity {
  UniEdgeModel({
    required super.sourceId,
    required super.targetId,
    required super.strength,
  });

  factory UniEdgeModel.fromJson(Map<String, dynamic> json) => UniEdgeModel(
        sourceId: json['source_id'] as String,
        targetId: json['target_id'] as String,
        strength: (json['strength'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'source_id': sourceId,
        'target_id': targetId,
        'strength': strength,
      };
}
