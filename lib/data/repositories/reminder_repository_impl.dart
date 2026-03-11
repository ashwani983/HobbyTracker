import 'package:drift/drift.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/database.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final AppDatabase _db;

  ReminderRepositoryImpl(this._db);

  @override
  Future<List<Reminder>> getRemindersByHobby(String hobbyId) async {
    try {
      final rows = await _db.getRemindersByHobby(hobbyId);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<List<Reminder>> getActiveReminders() async {
    try {
      final rows = await _db.getActiveReminders();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> createReminder(Reminder r) async {
    try {
      await _db.insertReminder(_toCompanion(r));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> updateReminder(Reminder r) async {
    try {
      await _db.updateReminder(_toCompanion(r));
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  @override
  Future<void> deleteReminder(String id) async {
    try {
      await _db.deleteReminder(id);
    } catch (e) {
      throw DatabaseFailure(e.toString());
    }
  }

  Reminder _toEntity(ReminderTableData row) => Reminder(
        id: row.id,
        hobbyId: row.hobbyId,
        hour: int.parse(row.time.split(':')[0]),
        minute: int.parse(row.time.split(':')[1]),
        weekDays: row.weekDays.split(',').map(int.parse).toList(),
        isActive: row.isActive,
      );

  ReminderTableCompanion _toCompanion(Reminder r) => ReminderTableCompanion(
        id: Value(r.id),
        hobbyId: Value(r.hobbyId),
        time: Value(r.timeString),
        weekDays: Value(r.weekDays.join(',')),
        isActive: Value(r.isActive),
      );
}
