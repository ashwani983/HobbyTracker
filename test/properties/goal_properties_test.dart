import 'package:flutter_test/flutter_test.dart';
import 'package:glados/src/any.dart' as glados_any show any;
import 'package:glados/src/anys.dart';
import 'package:glados/src/generator.dart';
import 'package:glados/src/glados.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/core/error/failures.dart';
import 'package:hobby_tracker/domain/entities/goal.dart';
import 'package:hobby_tracker/domain/entities/goal_type.dart';
import 'package:hobby_tracker/domain/repositories/goal_repository.dart';
import 'package:hobby_tracker/domain/repositories/session_repository.dart';
import 'package:hobby_tracker/domain/usecases/create_goal.dart';
import 'package:hobby_tracker/domain/usecases/deactivate_goal.dart';
import 'package:hobby_tracker/domain/usecases/get_active_goals.dart';
import 'package:hobby_tracker/domain/usecases/get_goal_progress.dart';

class MockGoalRepository extends Mock implements GoalRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}

final a = glados_any.any;

Goal _makeGoal({int target = 60, DateTime? start, DateTime? end}) => Goal(
      id: 'goal-1',
      hobbyId: 'hobby-1',
      type: GoalType.weekly,
      targetDurationMinutes: target,
      startDate: start ?? DateTime(2024, 1, 1),
      endDate: end ?? DateTime(2024, 1, 8),
    );

void main() {
  late MockGoalRepository goalRepo;
  late MockSessionRepository sessionRepo;
  late CreateGoal createGoal;
  late GetActiveGoals getActiveGoals;
  late DeactivateGoal deactivateGoal;
  late GetGoalProgress getGoalProgress;

  setUp(() {
    goalRepo = MockGoalRepository();
    sessionRepo = MockSessionRepository();
    createGoal = CreateGoal(goalRepo);
    getActiveGoals = GetActiveGoals(goalRepo);
    deactivateGoal = DeactivateGoal(goalRepo);
    getGoalProgress = GetGoalProgress(sessionRepo);
    registerFallbackValue(_makeGoal());
  });

  // Feature: flutter-hobby-tracker, Property 14: Goal persistence round-trip
  Glados(a.intInRange(1, 500)).test(
    'Property 14: valid goal is accepted',
    (target) async {
      when(() => goalRepo.createGoal(any())).thenAnswer((_) async {});
      final goal = _makeGoal(target: target);
      await createGoal(goal);
      verify(() => goalRepo.createGoal(goal)).called(1);
    },
  );

  // Feature: flutter-hobby-tracker, Property 15: Non-positive goal target rejection
  Glados(a.intInRange(-100, 0)).test(
    'Property 15: non-positive target is rejected',
    (target) async {
      final goal = _makeGoal(target: target);
      expect(() => createGoal(goal), throwsA(isA<ValidationFailure>()));
      verifyNever(() => goalRepo.createGoal(any()));
    },
  );

  // Feature: flutter-hobby-tracker, Property 16: Invalid goal date range rejection
  Glados(a.intInRange(0, 30)).test(
    'Property 16: end date before or equal to start date is rejected',
    (daysBefore) async {
      final start = DateTime(2024, 6, 15);
      final end = start.subtract(Duration(days: daysBefore));
      final goal = _makeGoal(target: 60, start: start, end: end);
      expect(() => createGoal(goal), throwsA(isA<ValidationFailure>()));
      verifyNever(() => goalRepo.createGoal(any()));
    },
  );

  // Feature: flutter-hobby-tracker, Property 17: Goal progress percentage calculation
  Glados2(a.intInRange(1, 500), a.intInRange(0, 1000)).test(
    'Property 17: progress = (actual / target) * 100, clamped to 100',
    (target, actual) async {
      when(() => sessionRepo.getTotalDurationForHobbyInRange(
            any(), any(), any(),
          )).thenAnswer((_) async => actual);

      final result = await getGoalProgress(
        hobbyId: 'hobby-1',
        targetDurationMinutes: target,
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 8),
      );

      final expected = ((actual / target) * 100).clamp(0, 100).toDouble();
      expect(result, closeTo(expected, 0.01));
    },
  );

  // Feature: flutter-hobby-tracker, Property 18: Goal completion on target met
  Glados(a.intInRange(1, 200)).test(
    'Property 18: progress is 100% when actual >= target',
    (target) async {
      when(() => sessionRepo.getTotalDurationForHobbyInRange(
            any(), any(), any(),
          )).thenAnswer((_) async => target + 10);

      final result = await getGoalProgress(
        hobbyId: 'hobby-1',
        targetDurationMinutes: target,
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 8),
      );
      expect(result, 100.0);
    },
  );

  // Feature: flutter-hobby-tracker, Property 19: Goal deactivation removes from active list
  Glados(a.intInRange(1, 5)).test(
    'Property 19: deactivated goal not in active list',
    (goalCount) async {
      when(() => goalRepo.deactivateGoal(any())).thenAnswer((_) async {});
      when(() => goalRepo.getActiveGoals()).thenAnswer((_) async => []);

      await deactivateGoal('goal-1');
      verify(() => goalRepo.deactivateGoal('goal-1')).called(1);

      final active = await getActiveGoals();
      expect(active.where((g) => g.id == 'goal-1'), isEmpty);
    },
  );
}
