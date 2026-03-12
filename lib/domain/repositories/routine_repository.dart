import '../entities/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getActiveRoutines();
  Future<Routine?> getRoutineById(String id);
  Future<void> createRoutine(Routine routine);
  Future<void> updateRoutine(Routine routine);
  Future<void> deleteRoutine(String id);
  Future<List<RoutineSchedule>> getSchedules(String routineId);
  Future<void> saveSchedules(String routineId, List<RoutineSchedule> schedules);
}
