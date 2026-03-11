import '../repositories/goal_repository.dart';

class DeactivateGoal {
  final GoalRepository _repository;

  DeactivateGoal(this._repository);

  Future<void> call(String id) async {
    await _repository.deactivateGoal(id);
  }
}
