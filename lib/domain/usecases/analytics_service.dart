import '../entities/session.dart';
import '../repositories/session_repository.dart';
import '../repositories/hobby_repository.dart';
import '../repositories/goal_repository.dart';
import '../repositories/badge_repository.dart';

class AnalyticsResult {
  final Map<String, Map<String, int>> correlationMatrix; // hobbyId -> hobbyId -> count
  final int? mostProductiveDow; // 1=Mon..7=Sun
  final int? mostProductiveHour;
  final Map<String, int> consistencyScores; // hobbyId -> 0-100
  final Map<String, double> avg7; // hobbyId -> 7-day avg minutes
  final Map<String, double> avg30; // hobbyId -> 30-day avg minutes
  final MonthlySummary? monthlySummary;

  const AnalyticsResult({
    this.correlationMatrix = const {},
    this.mostProductiveDow,
    this.mostProductiveHour,
    this.consistencyScores = const {},
    this.avg7 = const {},
    this.avg30 = const {},
    this.monthlySummary,
  });
}

class MonthlySummary {
  final int totalMinutes;
  final String? mostActiveHobbyId;
  final int longestStreak;
  final int goalsCompleted;
  final int badgesEarned;
  final int sessionsCount;

  const MonthlySummary({
    required this.totalMinutes,
    this.mostActiveHobbyId,
    required this.longestStreak,
    required this.goalsCompleted,
    required this.badgesEarned,
    required this.sessionsCount,
  });
}

class AnalyticsService {
  final SessionRepository _sessionRepo;
  final HobbyRepository _hobbyRepo;
  final GoalRepository _goalRepo;
  final BadgeRepository _badgeRepo;

  AnalyticsService(this._sessionRepo, this._hobbyRepo, this._goalRepo, this._badgeRepo);

  Future<AnalyticsResult> compute() async {
    final now = DateTime.now();
    final d30 = now.subtract(const Duration(days: 30));
    final d7 = now.subtract(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month);

    final sessions30 = await _sessionRepo.getSessionsInRange(d30, now);
    final sessions7 = sessions30.where((s) => s.date.isAfter(d7)).toList();
    final monthSessions = sessions30.where((s) => s.date.isAfter(monthStart)).toList();

    return AnalyticsResult(
      correlationMatrix: _correlation(sessions30),
      mostProductiveDow: _bestDow(sessions30),
      mostProductiveHour: _bestHour(sessions30),
      consistencyScores: _consistency(sessions30),
      avg7: _avgMinutes(sessions7, 7),
      avg30: _avgMinutes(sessions30, 30),
      monthlySummary: await _monthly(monthSessions),
    );
  }

  Map<String, Map<String, int>> _correlation(List<Session> sessions) {
    final byDay = <String, Set<String>>{};
    for (final s in sessions) {
      final key = '${s.date.year}-${s.date.month}-${s.date.day}';
      byDay.putIfAbsent(key, () => {}).add(s.hobbyId);
    }
    final matrix = <String, Map<String, int>>{};
    for (final hobbies in byDay.values) {
      final list = hobbies.toList();
      for (var i = 0; i < list.length; i++) {
        for (var j = i + 1; j < list.length; j++) {
          matrix.putIfAbsent(list[i], () => {})[list[j]] =
              (matrix[list[i]]?[list[j]] ?? 0) + 1;
          matrix.putIfAbsent(list[j], () => {})[list[i]] =
              (matrix[list[j]]?[list[i]] ?? 0) + 1;
        }
      }
    }
    return matrix;
  }

  int? _bestDow(List<Session> sessions) {
    if (sessions.isEmpty) return null;
    final counts = <int, int>{};
    for (final s in sessions) {
      counts[s.date.weekday] = (counts[s.date.weekday] ?? 0) + s.durationMinutes;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  int? _bestHour(List<Session> sessions) {
    if (sessions.isEmpty) return null;
    final counts = <int, int>{};
    for (final s in sessions) {
      counts[s.date.hour] = (counts[s.date.hour] ?? 0) + s.durationMinutes;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Map<String, int> _consistency(List<Session> sessions) {
    final byHobby = <String, Set<String>>{};
    for (final s in sessions) {
      final key = '${s.date.year}-${s.date.month}-${s.date.day}';
      byHobby.putIfAbsent(s.hobbyId, () => {}).add(key);
    }
    return byHobby.map((id, days) => MapEntry(id, ((days.length / 30) * 100).round().clamp(0, 100)));
  }

  Map<String, double> _avgMinutes(List<Session> sessions, int days) {
    final totals = <String, int>{};
    for (final s in sessions) {
      totals[s.hobbyId] = (totals[s.hobbyId] ?? 0) + s.durationMinutes;
    }
    return totals.map((id, total) => MapEntry(id, total / days));
  }

  Future<MonthlySummary> _monthly(List<Session> sessions) async {
    final totalMin = sessions.fold<int>(0, (a, s) => a + s.durationMinutes);
    String? topHobby;
    if (sessions.isNotEmpty) {
      final byHobby = <String, int>{};
      for (final s in sessions) {
        byHobby[s.hobbyId] = (byHobby[s.hobbyId] ?? 0) + s.durationMinutes;
      }
      final topId = byHobby.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      final hobby = await _hobbyRepo.getHobbyById(topId);
      topHobby = hobby?.name ?? topId;
    }
    final goals = await _goalRepo.getActiveGoals();
    final completed = goals.where((g) => !g.isActive).length;
    final badges = await _badgeRepo.getUnlockedBadges();

    return MonthlySummary(
      totalMinutes: totalMin,
      mostActiveHobbyId: topHobby,
      longestStreak: 0, // simplified
      goalsCompleted: completed,
      badgesEarned: badges.length,
      sessionsCount: sessions.length,
    );
  }
}
