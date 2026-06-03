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

  ProjectApplicationEntity copyWith({
    String? id,
    String? listingId,
    String? applicantId,
    String? applicantName,
    String? applicantAvatarUrl,
    String? coverMessage,
    String? phoneNumber,
    String? status,
    String? appliedAgo,
  }) => ProjectApplicationEntity(
    id: id ?? this.id,
    listingId: listingId ?? this.listingId,
    applicantId: applicantId ?? this.applicantId,
    applicantName: applicantName ?? this.applicantName,
    applicantAvatarUrl: applicantAvatarUrl ?? this.applicantAvatarUrl,
    coverMessage: coverMessage ?? this.coverMessage,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    status: status ?? this.status,
    appliedAgo: appliedAgo ?? this.appliedAgo,
  );
}
