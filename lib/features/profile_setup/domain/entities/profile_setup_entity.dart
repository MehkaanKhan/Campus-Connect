class ProfileSetupEntity {
  final String fullName;
  final String department;
  final String semester;
  final String? photoPath; // local file path, null until picked

  const ProfileSetupEntity({
    required this.fullName,
    required this.department,
    required this.semester,
    this.photoPath,
  });

  ProfileSetupEntity copyWith({
    String? fullName,
    String? department,
    String? semester,
    String? photoPath,
  }) =>
      ProfileSetupEntity(
        fullName: fullName ?? this.fullName,
        department: department ?? this.department,
        semester: semester ?? this.semester,
        photoPath: photoPath ?? this.photoPath,
      );
}
