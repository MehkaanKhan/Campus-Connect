class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? universityId;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.universityId,
  });
}
