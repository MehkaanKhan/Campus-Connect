class ProjectPartnerEntity {
  final String id;
  final String creatorId;
  final String badge;       // e.g. "ACADEMIC PROJECT"
  final String badgeColor;  // hex string e.g. "#8B6F4E"
  final String title;
  final String description;
  final List<String> skills;

  /// Total number of applications received for this listing.
  final int applicationCount;

  /// The authenticated user's application status for this listing.
  /// null = not applied, 'pending' | 'accepted' | 'rejected' otherwise.
  final String? currentUserApplicationStatus;

  const ProjectPartnerEntity({
    required this.id,
    required this.creatorId,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.description,
    required this.skills,
    this.applicationCount = 0,
    this.currentUserApplicationStatus,
  });

  bool get isOwner => false; // Resolved at presentation layer using SupabaseService.uid
}
