import '../repositories/session_repository.dart';

class GetGoalProgress {
  final SessionRepository _repository;

  GetGoalProgress(this._repository);

  /// Returns progress as a percentage (0.0 to 100.0), clamped at 100.
  Future<double> call({
    required String hobbyId,
    required int targetDurationMinutes,
    required DateTime start,
    required DateTime end,
  }) async {
    final total = await _repository.getTotalDurationForHobbyInRange(
      hobbyId,
      start,
      end,
    );
    if (targetDurationMinutes <= 0) return 0;
    final progress = (total / targetDurationMinutes) * 100;
    return progress.clamp(0, 100);
  }
}
