import 'package:drift/drift.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_type.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/database.dart';

class GoalRepositoryImpl implements GoalRepository {
  final AppDatabase _db;

  GoalRepositoryImpl(this._db);

  @override
  Future<List<Goal>> getActiveGoals() async {
    try {
      final rows = await _db.getActiveGoals();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<Goal>> getGoalsByHobby(String hobbyId) async {
    try {
      final rows = await _db.getGoalsByHobby(hobbyId);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> createGoal(Goal goal) async {
    try {
      await _db.insertGoal(_toCompanion(goal));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    try {
      await _db.updateGoal(_toCompanion(goal), goal.id);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> deactivateGoal(String id) async {
    try {
      await _db.deactivateGoal(id);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Goal _toEntity(GoalTableData row) => Goal(
        id: row.id,
        hobbyId: row.hobbyId,
        type: GoalType.values.byName(row.type),
        targetDurationMinutes: row.targetDurationMinutes,
        startDate: row.startDate,
        endDate: row.endDate,
        isActive: row.isActive,
      );

  GoalTableCompanion _toCompanion(Goal g) => GoalTableCompanion(
        id: Value(g.id),
        hobbyId: Value(g.hobbyId),
        type: Value(g.type.name),
        targetDurationMinutes: Value(g.targetDurationMinutes),
        startDate: Value(g.startDate),
        endDate: Value(g.endDate),
        isActive: Value(g.isActive),
      );
}
