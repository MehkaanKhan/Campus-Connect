import '../../domain/entities/profile_setup_entity.dart';

class ProfileSetupModel extends ProfileSetupEntity {
  const ProfileSetupModel({
    required super.fullName,
    required super.universityId,
    required super.department,
    required super.semester,
    super.photoBytes,
  });

  factory ProfileSetupModel.empty() => const ProfileSetupModel(
        fullName: '',
        universityId: '',
        department: '',
        semester: '',
      );

  factory ProfileSetupModel.fromJson(Map<String, dynamic> json) =>
      ProfileSetupModel(
        fullName: json['full_name'] as String,
        universityId: json['university_id'] as String,
        department: json['department'] as String,
        semester: json['semester'] as String,
      );

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'university_id': universityId,
        'department': department,
        'semester': semester,
      };
}
