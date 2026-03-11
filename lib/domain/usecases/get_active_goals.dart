import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

class GetActiveGoals {
  final GoalRepository _repository;

  GetActiveGoals(this._repository);

  Future<List<Goal>> call() async {
    return _repository.getActiveGoals();
  }
}
