import '../repositories/session_repository.dart';

class GetStreakCount {
  final SessionRepository _repo;

  GetStreakCount(this._repo);

  Future<int> call() async {
    final now = DateTime.now();
    final sessions = await _repo.getSessionsInRange(
      now.subtract(const Duration(days: 365)),
      now,
    );
    if (sessions.isEmpty) return 0;

    // Collect unique dates (year-month-day)
    final dates = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Streak must include today or yesterday
    if (dates.first != today && dates.first != yesterday) return 0;

    int streak = 1;
    for (var i = 1; i < dates.length; i++) {
      if (dates[i - 1].difference(dates[i]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
