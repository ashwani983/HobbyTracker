import '../../core/services/notification_service.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class ScheduleReminder {
  final ReminderRepository _repo;

  ScheduleReminder(this._repo);

  Future<void> call(Reminder reminder, String hobbyName) async {
    await _repo.createReminder(reminder);
    await _scheduleNotifications(reminder, hobbyName);
    // Confirm to user that reminder was saved
    await NotificationService.showNow(
      title: '✅ Reminder set for $hobbyName',
      body: '${reminder.timeString} on ${reminder.weekDaysSummary}',
    );
  }

  Future<void> _scheduleNotifications(Reminder r, String hobbyName) async {
    for (final day in r.weekDays) {
      await NotificationService.scheduleWeekly(
        id: r.id.hashCode + day,
        title: '🎯 Time for $hobbyName!',
        body: 'Your scheduled practice session is waiting.',
        hour: r.hour,
        minute: r.minute,
        weekDay: day,
        payload: r.hobbyId,
      );
    }
  }
}
