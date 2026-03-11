import '../../core/error/failures.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class LogSession {
  final SessionRepository _repository;

  LogSession(this._repository);

  Future<void> call(Session session) async {
    if (session.durationMinutes <= 0) {
      throw const ValidationFailure('Duration must be greater than zero');
    }
    if (session.rating != null && (session.rating! < 1 || session.rating! > 5)) {
      throw const ValidationFailure('Rating must be between 1 and 5');
    }
    await _repository.createSession(session);
  }
}
