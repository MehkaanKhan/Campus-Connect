/// Represents a single application to a project listing.
class ProjectApplicationEntity {
  final String id;
  final String listingId;
  final String applicantId;
  final String applicantName;
  final String? applicantAvatarUrl;
  final String coverMessage;
  final String? phoneNumber;

  /// One of: 'pending' | 'accepted' | 'rejected'
  final String status;
  final String appliedAgo;

  const ProjectApplicationEntity({
    required this.id,
    required this.listingId,
    required this.applicantId,
    required this.applicantName,
    this.applicantAvatarUrl,
    required this.coverMessage,
    this.phoneNumber,
    required this.status,
    required this.appliedAgo,
  });

  bool get isPending  => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
