import '../entities/session.dart';

abstract class SessionRepository {
  Future<List<Session>> getSessionsByHobby(String hobbyId);
  Future<List<Session>> getSessionsInRange(DateTime start, DateTime end);
  Future<List<Session>> getRecentSessions(int limit);
  Future<int> getTotalDurationForHobbyInRange(
    String hobbyId,
    DateTime start,
    DateTime end,
  );
  Future<void> createSession(Session session);
  Future<void> deleteSession(String id);
}
