import '../../core/error/failures.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class UpdateGoal {
  final GoalRepository _repository;

  UpdateGoal(this._repository);

  Future<void> call(Goal goal) async {
    if (goal.targetDurationMinutes <= 0) {
      throw const ValidationFailure(
        'Target duration must be greater than zero',
      );
    }
    if (!goal.endDate.isAfter(goal.startDate)) {
      throw const ValidationFailure('End date must be after start date');
    }
    await _repository.updateGoal(goal);
  }
}
