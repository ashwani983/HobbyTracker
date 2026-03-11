import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetSessionsByHobby {
  final SessionRepository _repository;

  GetSessionsByHobby(this._repository);

  Future<List<Session>> call(String hobbyId) async {
    return _repository.getSessionsByHobby(hobbyId);
  }
}
