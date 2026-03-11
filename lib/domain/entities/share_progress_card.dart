class ShareProgressCard {
  final String hobbyName;
  final String category;
  final int totalSessions;
  final int totalMinutes;
  final int streakDays;
  final String? badgeEmoji;
  final String? badgeTitle;

  const ShareProgressCard({
    required this.hobbyName,
    required this.category,
    required this.totalSessions,
    required this.totalMinutes,
    required this.streakDays,
    this.badgeEmoji,
    this.badgeTitle,
  });
}
