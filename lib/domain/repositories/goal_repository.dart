import '../entities/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getActiveGoals();
  Future<List<Goal>> getGoalsByHobby(String hobbyId);
  Future<void> createGoal(Goal goal);
  Future<void> deactivateGoal(String id);
}
