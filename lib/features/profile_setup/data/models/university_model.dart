import '../../domain/entities/university_entity.dart';

class UniversityModel extends UniversityEntity {
  const UniversityModel({
    required super.id,
    required super.name,
    super.logoText,
    super.region,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) {
    return UniversityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoText: json['logo_text'] as String?,
      region: json['region'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_text': logoText,
      'region': region,
    };
  }
}
