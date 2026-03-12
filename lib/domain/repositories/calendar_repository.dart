import '../entities/session.dart';

abstract class CalendarRepository {
  Future<bool> requestPermission();
  Future<void> syncSessionToCalendar(Session session, String hobbyName);
  Future<void> removeSessionFromCalendar(String sessionId);
}
