class Challenge {
  final String id;
  final String name;
  final String category;
  final int targetMinutes;
  final DateTime startDate;
  final DateTime endDate;
  final String inviteCode;
  final int participantLimit;
  final String creatorUid;
  final bool isActive;

  const Challenge({
    required this.id,
    required this.name,
    required this.category,
    required this.targetMinutes,
    required this.startDate,
    required this.endDate,
    required this.inviteCode,
    required this.participantLimit,
    required this.creatorUid,
    this.isActive = true,
  });

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'category': category,
        'targetMinutes': targetMinutes,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'inviteCode': inviteCode,
        'participantLimit': participantLimit,
        'creatorUid': creatorUid,
        'isActive': isActive,
      };

  factory Challenge.fromFirestore(String id, Map<String, dynamic> d) =>
      Challenge(
        id: id,
        name: d['name'] as String,
        category: d['category'] as String,
        targetMinutes: d['targetMinutes'] as int,
        startDate: DateTime.parse(d['startDate'] as String),
        endDate: DateTime.parse(d['endDate'] as String),
        inviteCode: d['inviteCode'] as String,
        participantLimit: d['participantLimit'] as int,
        creatorUid: d['creatorUid'] as String,
        isActive: d['isActive'] as bool? ?? true,
      );
}

class LeaderboardEntry {
  final String uid;
  final String displayName;
  final int totalMinutes;

  const LeaderboardEntry({
    required this.uid,
    required this.displayName,
    required this.totalMinutes,
  });
}
