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

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? universityId,
  }) => UserEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    universityId: universityId ?? this.universityId,
  );
}
