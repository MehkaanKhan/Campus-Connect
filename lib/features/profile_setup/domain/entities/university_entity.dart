class UniversityEntity {
  final String id;
  final String name;
  final String? logoText;
  final String? region;

  const UniversityEntity({
    required this.id,
    required this.name,
    this.logoText,
    this.region,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniversityEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
