import 'package:drift/drift.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/badge_repository.dart';
import '../datasources/database.dart';

class BadgeRepositoryImpl implements BadgeRepository {
  final AppDatabase _db;

  BadgeRepositoryImpl(this._db);

  @override
  Future<List<Badge>> getUnlockedBadges() async {
    try {
      final rows = await _db.getAllBadges();
      final unlockedIds = {for (final r in rows) r.id: r.unlockedAt};
      return Badge.all.map((b) {
        final at = unlockedIds[b.id];
        return at != null ? b.unlock(at) : b;
      }).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> unlockBadge(Badge badge) async {
    try {
      await _db.insertBadge(UserBadgeTableCompanion(
        id: Value(badge.id),
        badgeType: Value(badge.type.name),
        unlockedAt: Value(badge.unlockedAt ?? DateTime.now()),
      ));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }
}
