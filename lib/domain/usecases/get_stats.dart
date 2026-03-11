import '../repositories/hobby_repository.dart';
import '../repositories/session_repository.dart';

class StatsResult {
  final Map<String, int> perHobbyDurations;
  final Map<String, double> perHobbyProportions;
  final Map<DateTime, int> dailyTotals;

  const StatsResult({
    required this.perHobbyDurations,
    required this.perHobbyProportions,
    required this.dailyTotals,
  });
}

class GetStats {
  final SessionRepository _sessionRepository;
  final HobbyRepository _hobbyRepository;

  GetStats(this._sessionRepository, this._hobbyRepository);

  Future<StatsResult> call(DateTime start, DateTime end) async {
    final sessions = await _sessionRepository.getSessionsInRange(start, end);

    // Aggregate by hobbyId first
    final perIdDurations = <String, int>{};
    final daily = <DateTime, int>{};

    for (final s in sessions) {
      perIdDurations[s.hobbyId] =
          (perIdDurations[s.hobbyId] ?? 0) + s.durationMinutes;
      final day = DateTime(s.date.year, s.date.month, s.date.day);
      daily[day] = (daily[day] ?? 0) + s.durationMinutes;
    }

    // Resolve hobby names
    final perHobby = <String, int>{};
    for (final entry in perIdDurations.entries) {
      final hobby = await _hobbyRepository.getHobbyById(entry.key);
      final name = hobby?.name ?? 'Unknown';
      perHobby[name] = entry.value;
    }

    final grandTotal = perHobby.values.fold<int>(0, (a, b) => a + b);
    final proportions = <String, double>{};
    if (grandTotal > 0) {
      for (final entry in perHobby.entries) {
        proportions[entry.key] = entry.value / grandTotal;
      }
    }

    return StatsResult(
      perHobbyDurations: perHobby,
      perHobbyProportions: proportions,
      dailyTotals: daily,
    );
  }
}
