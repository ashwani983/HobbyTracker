import '../../core/services/notification_service.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

class CancelReminder {
  final ReminderRepository _repo;

  CancelReminder(this._repo);

  Future<void> call(Reminder reminder) async {
    for (final day in reminder.weekDays) {
      await NotificationService.cancel(reminder.id.hashCode + day);
    }
    await _repo.deleteReminder(reminder.id);
  }
}
