import '../../domain/entities/profile_setup_entity.dart';

class ProfileSetupModel extends ProfileSetupEntity {
  const ProfileSetupModel({
    required super.fullName,
    required super.department,
    required super.semester,
    super.photoPath,
  });

  factory ProfileSetupModel.empty() => const ProfileSetupModel(
        fullName: '',
        department: '',
        semester: '',
      );

  factory ProfileSetupModel.fromJson(Map<String, dynamic> json) =>
      ProfileSetupModel(
        fullName: json['full_name'] as String,
        department: json['department'] as String,
        semester: json['semester'] as String,
        photoPath: json['photo_path'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'department': department,
        'semester': semester,
        'photo_path': photoPath,
      };
}
