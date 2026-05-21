enum ComplaintStatus { pending, reviewed, resolved, dismissed }

class ComplaintEntity {
  final String id;
  final String itemId;
  final String reporterId;
  final String reason;
  final String details;
  final ComplaintStatus status;
  final DateTime createdAt;

  const ComplaintEntity({
    required this.id,
    required this.itemId,
    required this.reporterId,
    required this.reason,
    required this.details,
    required this.status,
    required this.createdAt,
  });

  ComplaintEntity copyWith({
    String? id,
    String? itemId,
    String? reporterId,
    String? reason,
    String? details,
    ComplaintStatus? status,
    DateTime? createdAt,
  }) {
    return ComplaintEntity(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      reporterId: reporterId ?? this.reporterId,
      reason: reason ?? this.reason,
      details: details ?? this.details,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
