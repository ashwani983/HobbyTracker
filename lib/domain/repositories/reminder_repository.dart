import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getRemindersByHobby(String hobbyId);
  Future<List<Reminder>> getActiveReminders();
  Future<void> createReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
}
