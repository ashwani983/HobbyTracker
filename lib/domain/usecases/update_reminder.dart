import '../../core/services/notification_service.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminder {
  final ReminderRepository _repo;

  UpdateReminder(this._repo);

  Future<void> call(Reminder reminder, String hobbyName) async {
    // Cancel all 7 possible day slots for this reminder
    for (var day = 1; day <= 7; day++) {
      await NotificationService.cancel(reminder.id.hashCode + day);
    }
    await _repo.updateReminder(reminder);
    // Re-schedule only selected days
    for (final day in reminder.weekDays) {
      await NotificationService.scheduleWeekly(
        id: reminder.id.hashCode + day,
        title: '🎯 Time for $hobbyName!',
        body: 'Your scheduled practice session is waiting.',
        hour: reminder.hour,
        minute: reminder.minute,
        weekDay: day,
        payload: reminder.hobbyId,
      );
    }
  }
}
