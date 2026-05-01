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
        fullName: json['fullName'] as String,
        department: json['department'] as String,
        semester: json['semester'] as String,
        photoPath: json['photoPath'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'department': department,
        'semester': semester,
        'photoPath': photoPath,
      };
}
