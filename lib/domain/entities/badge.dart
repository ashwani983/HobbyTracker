import 'badge_type.dart';

class Badge {
  final String id;
  final String title;
  final String emoji;
  final BadgeType type;
  final int threshold;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.title,
    required this.emoji,
    required this.type,
    required this.threshold,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  Badge unlock(DateTime at) => Badge(
        id: id,
        title: title,
        emoji: emoji,
        type: type,
        threshold: threshold,
        unlockedAt: at,
      );

  static const List<Badge> all = [
    Badge(id: 'streak_3', title: '3-Day Streak', emoji: '🔥', type: BadgeType.streak, threshold: 3),
    Badge(id: 'streak_7', title: 'Week Warrior', emoji: '⚡', type: BadgeType.streak, threshold: 7),
    Badge(id: 'streak_30', title: 'Monthly Master', emoji: '🏆', type: BadgeType.streak, threshold: 30),
    Badge(id: 'streak_100', title: 'Century Club', emoji: '💎', type: BadgeType.streak, threshold: 100),
    Badge(id: 'milestone_1', title: 'First Step', emoji: '👣', type: BadgeType.milestone, threshold: 1),
    Badge(id: 'milestone_10', title: 'Getting Serious', emoji: '💪', type: BadgeType.milestone, threshold: 10),
    Badge(id: 'milestone_50', title: 'Dedicated', emoji: '🎯', type: BadgeType.milestone, threshold: 50),
    Badge(id: 'milestone_100', title: 'Centurion', emoji: '🏅', type: BadgeType.milestone, threshold: 100),
    Badge(id: 'time_60', title: 'First Hour', emoji: '⏰', type: BadgeType.time, threshold: 60),
    Badge(id: 'time_600', title: 'Time Investor', emoji: '📈', type: BadgeType.time, threshold: 600),
    Badge(id: 'time_6000', title: 'Master of Time', emoji: '⌛', type: BadgeType.time, threshold: 6000),
    Badge(id: 'explorer_3', title: 'Explorer', emoji: '🧭', type: BadgeType.explorer, threshold: 3),
    Badge(id: 'explorer_5', title: 'Adventurer', emoji: '🗺️', type: BadgeType.explorer, threshold: 5),
    Badge(id: 'explorer_10', title: 'Renaissance', emoji: '🎭', type: BadgeType.explorer, threshold: 10),
  ];
}
