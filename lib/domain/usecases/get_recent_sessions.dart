import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetRecentSessions {
  final SessionRepository _repository;

  GetRecentSessions(this._repository);

  Future<List<Session>> call(int limit) async {
    return _repository.getRecentSessions(limit);
  }
}
