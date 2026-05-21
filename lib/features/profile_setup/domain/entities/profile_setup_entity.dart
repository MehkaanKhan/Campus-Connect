import 'dart:typed_data';

class ProfileSetupEntity {
  final String fullName;
  final String universityId;
  final String department;
  final String semester;
  final Uint8List? photoBytes; 

  const ProfileSetupEntity({
    required this.fullName,
    required this.universityId,
    required this.department,
    required this.semester,
    this.photoBytes,
  });

  ProfileSetupEntity copyWith({
    String? fullName,
    String? universityId,
    String? department,
    String? semester,
    Uint8List? photoBytes,
  }) =>
      ProfileSetupEntity(
        fullName: fullName ?? this.fullName,
        universityId: universityId ?? this.universityId,
        department: department ?? this.department,
        semester: semester ?? this.semester,
        photoBytes: photoBytes ?? this.photoBytes,
      );
}
