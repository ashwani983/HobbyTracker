import '../entities/badge.dart';
import '../entities/badge_type.dart';
import '../repositories/badge_repository.dart';
import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';
import 'get_streak_count.dart';

class CheckBadges {
  final BadgeRepository _badgeRepo;
  final SessionRepository _sessionRepo;
  final HobbyRepository _hobbyRepo;
  final GetStreakCount _getStreak;

  CheckBadges(this._badgeRepo, this._sessionRepo, this._hobbyRepo, this._getStreak);

  /// Returns list of newly unlocked badges.
  Future<List<Badge>> call() async {
    final allBadges = await _badgeRepo.getUnlockedBadges();
    final locked = allBadges.where((b) => !b.isUnlocked).toList();
    if (locked.isEmpty) return [];

    final now = DateTime.now();
    final streak = await _getStreak();
    final allSessions = await _sessionRepo.getSessionsInRange(
      DateTime(2000),
      now,
    );
    final totalSessions = allSessions.length;
    final totalMinutes = allSessions.fold<int>(0, (s, e) => s + e.durationMinutes);
    final hobbies = await _hobbyRepo.getActiveHobbies();
    final hobbyCount = hobbies.length;

    final newlyUnlocked = <Badge>[];

    for (final badge in locked) {
      final int value;
      switch (badge.type) {
        case BadgeType.streak:
          value = streak;
        case BadgeType.milestone:
          value = totalSessions;
        case BadgeType.time:
          value = totalMinutes;
        case BadgeType.explorer:
          value = hobbyCount;
      }
      if (value >= badge.threshold) {
        final unlocked = badge.unlock(now);
        await _badgeRepo.unlockBadge(unlocked);
        newlyUnlocked.add(unlocked);
      }
    }

    return newlyUnlocked;
  }
}
