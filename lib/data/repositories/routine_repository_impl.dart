import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/entities/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../datasources/database.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final AppDatabase _db;
  RoutineRepositoryImpl(this._db);

  Routine _toEntity(RoutineTableData r) => Routine(
        id: r.uid,
        name: r.name,
        steps: (jsonDecode(r.hobbySequence) as List)
            .map((e) => RoutineStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        isActive: r.isActive,
        createdAt: r.createdAt,
        updatedAt: r.updatedAt,
      );

  @override
  Future<List<Routine>> getActiveRoutines() async =>
      (await _db.getActiveRoutines()).map(_toEntity).toList();

  @override
  Future<Routine?> getRoutineById(String id) async {
    final r = await _db.getRoutineByUid(id);
    return r == null ? null : _toEntity(r);
  }

  @override
  Future<void> createRoutine(Routine routine) => _db.insertRoutine(
        RoutineTableCompanion.insert(
          uid: routine.id,
          name: routine.name,
          hobbySequence: jsonEncode(routine.steps.map((s) => s.toJson()).toList()),
          createdAt: routine.createdAt,
          updatedAt: routine.updatedAt,
        ),
      );

  @override
  Future<void> updateRoutine(Routine routine) => _db.updateRoutineByUid(
        routine.id,
        RoutineTableCompanion(
          name: Value(routine.name),
          hobbySequence: Value(jsonEncode(routine.steps.map((s) => s.toJson()).toList())),
          isActive: Value(routine.isActive),
          updatedAt: Value(routine.updatedAt),
        ),
      );

  @override
  Future<void> deleteRoutine(String id) => _db.deleteRoutine(id);

  @override
  Future<List<RoutineSchedule>> getSchedules(String routineId) async =>
      (await _db.getSchedulesForRoutine(routineId))
          .map((s) => RoutineSchedule(
                dbId: s.id,
                routineId: s.routineUid,
                dayOfWeek: s.dayOfWeek,
                hour: s.hour,
                minute: s.minute,
              ))
          .toList();

  @override
  Future<void> saveSchedules(String routineId, List<RoutineSchedule> schedules) async {
    await _db.deleteSchedulesForRoutine(routineId);
    for (final s in schedules) {
      await _db.insertSchedule(RoutineScheduleTableCompanion.insert(
        routineUid: routineId,
        dayOfWeek: s.dayOfWeek,
        hour: s.hour,
        minute: s.minute,
      ));
    }
  }
}
