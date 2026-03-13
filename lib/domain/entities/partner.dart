class Partner {
  final String id;
  final String partnerUid;
  final String partnerDisplayName;
  final DateTime linkedAt;
  final bool isActive;

  const Partner({
    required this.id,
    required this.partnerUid,
    required this.partnerDisplayName,
    required this.linkedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toFirestore() => {
        'partnerUid': partnerUid,
        'partnerDisplayName': partnerDisplayName,
        'linkedAt': linkedAt.toIso8601String(),
        'isActive': isActive,
      };

  factory Partner.fromFirestore(String id, Map<String, dynamic> data) => Partner(
        id: id,
        partnerUid: data['partnerUid'] as String,
        partnerDisplayName: data['partnerDisplayName'] as String,
        linkedAt: DateTime.parse(data['linkedAt'] as String),
        isActive: data['isActive'] as bool? ?? true,
      );
}

class PartnerStats {
  final String partnerUid;
  final String displayName;
  final int currentStreak;
  final int weeklyMinutes;
  final int goalCompletionPercent;

  const PartnerStats({
    required this.partnerUid,
    required this.displayName,
    this.currentStreak = 0,
    this.weeklyMinutes = 0,
    this.goalCompletionPercent = 0,
  });
}
