import '../../domain/entities/other_uni_entity.dart';

class OtherUniModel extends OtherUniEntity {
  OtherUniModel({
    required super.id,
    required super.name,
    required super.region,
    required super.memberCount,
    required super.activityScore,
    required super.logoText,
    required super.description,
  });

  factory OtherUniModel.fromJson(Map<String, dynamic> json) => OtherUniModel(
        id: json['id'] as String,
        name: json['name'] as String,
        region: json['region'] as String,
        memberCount: json['member_count'] as int,
        activityScore: json['activity_score'] as int,
        logoText: json['logo_text'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'region': region,
        'member_count': memberCount,
        'activity_score': activityScore,
        'logo_text': logoText,
        'description': description,
      };
}
