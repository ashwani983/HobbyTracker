import 'package:flutter_test/flutter_test.dart';
import 'package:glados/src/any.dart' as glados_any show any;
import 'package:glados/src/anys.dart';
import 'package:glados/src/generator.dart';
import 'package:glados/src/glados.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/domain/repositories/hobby_repository.dart';
import 'package:hobby_tracker/domain/repositories/session_repository.dart';
import 'package:hobby_tracker/domain/usecases/get_stats.dart';

class MockSessionRepository extends Mock implements SessionRepository {}
class MockHobbyRepository extends Mock implements HobbyRepository {}

final a = glados_any.any;

void main() {
  late MockSessionRepository repo;
  late MockHobbyRepository hobbyRepo;
  late GetStats getStats;

  setUp(() {
    repo = MockSessionRepository();
    hobbyRepo = MockHobbyRepository();
    getStats = GetStats(repo, hobbyRepo);
    // Default: return a hobby with name matching id
    when(() => hobbyRepo.getHobbyById(any())).thenAnswer((inv) async {
      final id = inv.positionalArguments[0] as String;
      return Hobby(
        id: id,
        name: id,
        category: 'Other',
        iconName: 'star',
        color: 0xFF000000,
        createdAt: DateTime(2024),
      );
    });
  });

  // Feature: flutter-hobby-tracker, Property 20: Stats per-hobby aggregation and proportions
  Glados(a.intInRange(1, 5)).test(
    'Property 20: per-hobby durations sum correctly and proportions sum to 1',
    (hobbyCount) async {
      final sessions = List.generate(
        hobbyCount * 2,
        (i) => Session(
          id: 'id-$i',
          hobbyId: 'hobby-${i % hobbyCount}',
          date: DateTime(2024, 1, 2),
          durationMinutes: 30,
          createdAt: DateTime(2024),
        ),
      );
      when(() => repo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);

      final result = await getStats(DateTime(2024, 1, 1), DateTime(2024, 1, 31));

      final totalFromMap =
          result.perHobbyDurations.values.fold<int>(0, (a, b) => a + b);
      final totalFromSessions =
          sessions.fold<int>(0, (a, s) => a + s.durationMinutes);
      expect(totalFromMap, totalFromSessions);

      if (result.perHobbyProportions.isNotEmpty) {
        final proportionSum =
            result.perHobbyProportions.values.fold<double>(0, (a, b) => a + b);
        expect(proportionSum, closeTo(1.0, 0.001));
      }
    },
  );

  // Feature: flutter-hobby-tracker, Property 21: Stats daily aggregation
  Glados(a.intInRange(1, 7)).test(
    'Property 21: daily totals sum matches session totals',
    (dayCount) async {
      final sessions = List.generate(
        dayCount,
        (i) => Session(
          id: 'id-$i',
          hobbyId: 'hobby-1',
          date: DateTime(2024, 1, i + 1),
          durationMinutes: 45,
          createdAt: DateTime(2024),
        ),
      );
      when(() => repo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);

      final result = await getStats(DateTime(2024, 1, 1), DateTime(2024, 1, 31));

      final dailySum =
          result.dailyTotals.values.fold<int>(0, (a, b) => a + b);
      expect(dailySum, dayCount * 45);
    },
  );

  // Feature: flutter-hobby-tracker, Property 22: Stats excludes hobbies with no sessions
  test('Property 22: empty sessions produce empty stats', () async {
    when(() => repo.getSessionsInRange(any(), any()))
        .thenAnswer((_) async => []);

    final result = await getStats(DateTime(2024, 1, 1), DateTime(2024, 1, 31));

    expect(result.perHobbyDurations, isEmpty);
    expect(result.perHobbyProportions, isEmpty);
    expect(result.dailyTotals, isEmpty);
  });
}
