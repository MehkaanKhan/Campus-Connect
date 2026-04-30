class ProjectPartnerEntity {
  final String id;
  final String badge;       // e.g. "ACADEMIC PROJECT"
  final String badgeColor;  // hex string e.g. "#8B6F4E"
  final String title;
  final String description;
  final List<String> skills;

  const ProjectPartnerEntity({
    required this.id,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.skills,
  });
}
