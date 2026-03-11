import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/domain/entities/badge.dart';
import 'package:hobby_tracker/domain/entities/badge_type.dart';
import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/domain/repositories/badge_repository.dart';
import 'package:hobby_tracker/domain/repositories/hobby_repository.dart';
import 'package:hobby_tracker/domain/repositories/session_repository.dart';
import 'package:hobby_tracker/domain/usecases/check_badges.dart';
import 'package:hobby_tracker/domain/usecases/get_streak_count.dart';

class MockSessionRepo extends Mock implements SessionRepository {}
class MockHobbyRepo extends Mock implements HobbyRepository {}
class MockBadgeRepo extends Mock implements BadgeRepository {}

void main() {
  late MockSessionRepo sessionRepo;
  late MockHobbyRepo hobbyRepo;
  late MockBadgeRepo badgeRepo;

  setUp(() {
    sessionRepo = MockSessionRepo();
    hobbyRepo = MockHobbyRepo();
    badgeRepo = MockBadgeRepo();
    registerFallbackValue(Badge.all.first.unlock(DateTime.now()));
  });

  Session _session(DateTime date) => Session(
        id: 'id',
        hobbyId: 'h1',
        date: date,
        durationMinutes: 30,
        createdAt: date,
      );

  group('GetStreakCount', () {
    late GetStreakCount getStreak;

    setUp(() => getStreak = GetStreakCount(sessionRepo));

    test('returns 0 when no sessions', () async {
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => []);
      expect(await getStreak(), 0);
    });

    test('returns 1 for session today only', () async {
      final today = DateTime.now();
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => [_session(today)]);
      expect(await getStreak(), 1);
    });

    test('counts consecutive days', () async {
      final today = DateTime.now();
      final sessions = List.generate(
        5,
        (i) => _session(today.subtract(Duration(days: i))),
      );
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
      expect(await getStreak(), 5);
    });

    test('breaks on gap', () async {
      final today = DateTime.now();
      final sessions = [
        _session(today),
        _session(today.subtract(const Duration(days: 1))),
        // gap: day 2 missing
        _session(today.subtract(const Duration(days: 3))),
      ];
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
      expect(await getStreak(), 2);
    });

    test('deduplicates same-day sessions', () async {
      final today = DateTime.now();
      final sessions = [
        _session(today),
        _session(today), // duplicate
        _session(today.subtract(const Duration(days: 1))),
      ];
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
      expect(await getStreak(), 2);
    });
  });

  group('CheckBadges', () {
    late CheckBadges checkBadges;
    late GetStreakCount getStreak;

    setUp(() {
      getStreak = GetStreakCount(sessionRepo);
      checkBadges = CheckBadges(badgeRepo, sessionRepo, hobbyRepo, getStreak);
    });

    test('unlocks milestone badge when threshold met', () async {
      // 1 session → should unlock "First Step" (milestone, threshold 1)
      final today = DateTime.now();
      when(() => badgeRepo.getUnlockedBadges())
          .thenAnswer((_) async => Badge.all); // all locked
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => [_session(today)]);
      when(() => hobbyRepo.getActiveHobbies())
          .thenAnswer((_) async => []);
      when(() => badgeRepo.unlockBadge(any())).thenAnswer((_) async {});

      final result = await checkBadges();
      final ids = result.map((b) => b.id).toSet();
      expect(ids.contains('milestone_1'), true);
    });

    test('unlocks time badge when total minutes met', () async {
      final today = DateTime.now();
      // 60 min total → should unlock "First Hour" (time, threshold 60)
      final sessions = [
        Session(id: 's1', hobbyId: 'h1', date: today, durationMinutes: 60, createdAt: today),
      ];
      when(() => badgeRepo.getUnlockedBadges())
          .thenAnswer((_) async => Badge.all);
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
      when(() => hobbyRepo.getActiveHobbies())
          .thenAnswer((_) async => []);
      when(() => badgeRepo.unlockBadge(any())).thenAnswer((_) async {});

      final result = await checkBadges();
      final ids = result.map((b) => b.id).toSet();
      expect(ids.contains('time_60'), true);
    });

    test('unlocks explorer badge when hobby count met', () async {
      final today = DateTime.now();
      final hobbies = List.generate(
        3,
        (i) => Hobby(
          id: 'h$i', name: 'H$i', category: 'Other',
          iconName: 'x', color: 0, createdAt: today,
        ),
      );
      when(() => badgeRepo.getUnlockedBadges())
          .thenAnswer((_) async => Badge.all);
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => []);
      when(() => hobbyRepo.getActiveHobbies())
          .thenAnswer((_) async => hobbies);
      when(() => badgeRepo.unlockBadge(any())).thenAnswer((_) async {});

      final result = await checkBadges();
      final ids = result.map((b) => b.id).toSet();
      expect(ids.contains('explorer_3'), true);
    });

    test('does not re-unlock already unlocked badges', () async {
      final today = DateTime.now();
      final alreadyUnlocked = Badge.all.map((b) => b.unlock(today)).toList();
      when(() => badgeRepo.getUnlockedBadges())
          .thenAnswer((_) async => alreadyUnlocked);

      final result = await checkBadges();
      expect(result, isEmpty);
    });
  });
}
