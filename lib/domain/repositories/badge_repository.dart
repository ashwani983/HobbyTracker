import '../entities/badge.dart';

abstract class BadgeRepository {
  Future<List<Badge>> getUnlockedBadges();
  Future<void> unlockBadge(Badge badge);
}
