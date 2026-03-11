import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hobby_tracker/data/datasources/database.dart';
import 'package:hobby_tracker/data/repositories/hobby_repository_impl.dart';
import 'package:hobby_tracker/data/repositories/session_repository_impl.dart';
import 'package:hobby_tracker/data/repositories/goal_repository_impl.dart';
import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/domain/entities/goal.dart';
import 'package:hobby_tracker/domain/entities/goal_type.dart';
import 'package:hobby_tracker/core/error/failures.dart';

void main() {
  late AppDatabase db;
  late HobbyRepositoryImpl hobbyRepo;
  late SessionRepositoryImpl sessionRepo;
  late GoalRepositoryImpl goalRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    hobbyRepo = HobbyRepositoryImpl(db);
    sessionRepo = SessionRepositoryImpl(db);
    goalRepo = GoalRepositoryImpl(db);
  });

  tearDown(() => db.close());

  Hobby _hobby({String id = 'h1', String name = 'Guitar', bool archived = false}) =>
      Hobby(
        id: id,
        name: name,
        category: 'Music',
        iconName: 'interests',
        color: 0xFF2196F3,
        createdAt: DateTime(2025, 1, 1),
        isArchived: archived,
      );

  Session _session({
    String id = 's1',
    String hobbyId = 'h1',
    int minutes = 30,
    DateTime? date,
  }) =>
      Session(
        id: id,
        hobbyId: hobbyId,
        date: date ?? DateTime(2025, 3, 10),
        durationMinutes: minutes,
        createdAt: DateTime(2025, 3, 10),
      );

  Goal _goal({String id = 'g1', String hobbyId = 'h1', bool active = true}) =>
      Goal(
        id: id,
        hobbyId: hobbyId,
        type: GoalType.weekly,
        targetDurationMinutes: 120,
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 31),
        isActive: active,
      );

  // ── HobbyRepository ──

  group('HobbyRepositoryImpl', () {
    test('createHobby + getActiveHobbies', () async {
      await hobbyRepo.createHobby(_hobby());
      final list = await hobbyRepo.getActiveHobbies();
      expect(list.length, 1);
      expect(list.first.name, 'Guitar');
    });

    test('getHobbyById returns hobby', () async {
      await hobbyRepo.createHobby(_hobby());
      final h = await hobbyRepo.getHobbyById('h1');
      expect(h, isNotNull);
      expect(h!.id, 'h1');
    });

    test('getHobbyById returns null for missing id', () async {
      final h = await hobbyRepo.getHobbyById('missing');
      expect(h, isNull);
    });

    test('updateHobby changes fields', () async {
      await hobbyRepo.createHobby(_hobby());
      await hobbyRepo.updateHobby(_hobby().copyWith(name: 'Piano'));
      final h = await hobbyRepo.getHobbyById('h1');
      expect(h!.name, 'Piano');
    });

    test('archiveHobby hides from active list', () async {
      await hobbyRepo.createHobby(_hobby());
      await hobbyRepo.archiveHobby('h1');
      final list = await hobbyRepo.getActiveHobbies();
      expect(list, isEmpty);
    });

    test('archived hobby still retrievable by id', () async {
      await hobbyRepo.createHobby(_hobby());
      await hobbyRepo.archiveHobby('h1');
      final h = await hobbyRepo.getHobbyById('h1');
      expect(h, isNotNull);
      expect(h!.isArchived, true);
    });
  });

  // ── SessionRepository ──

  group('SessionRepositoryImpl', () {
    setUp(() async {
      await hobbyRepo.createHobby(_hobby());
    });

    test('createSession + getSessionsByHobby', () async {
      await sessionRepo.createSession(_session());
      final list = await sessionRepo.getSessionsByHobby('h1');
      expect(list.length, 1);
      expect(list.first.durationMinutes, 30);
    });

    test('getRecentSessions respects limit', () async {
      for (var i = 0; i < 5; i++) {
        await sessionRepo.createSession(_session(
          id: 's$i',
          date: DateTime(2025, 3, 10 + i),
        ));
      }
      final recent = await sessionRepo.getRecentSessions(3);
      expect(recent.length, 3);
    });

    test('getSessionsInRange filters correctly', () async {
      await sessionRepo.createSession(_session(id: 's1', date: DateTime(2025, 3, 5)));
      await sessionRepo.createSession(_session(id: 's2', date: DateTime(2025, 3, 15)));
      await sessionRepo.createSession(_session(id: 's3', date: DateTime(2025, 3, 25)));

      final range = await sessionRepo.getSessionsInRange(
        DateTime(2025, 3, 10),
        DateTime(2025, 3, 20),
      );
      expect(range.length, 1);
      expect(range.first.id, 's2');
    });

    test('getTotalDurationForHobbyInRange sums correctly', () async {
      await sessionRepo.createSession(_session(id: 's1', minutes: 30, date: DateTime(2025, 3, 10)));
      await sessionRepo.createSession(_session(id: 's2', minutes: 45, date: DateTime(2025, 3, 12)));
      await sessionRepo.createSession(_session(id: 's3', minutes: 60, date: DateTime(2025, 3, 25)));

      final total = await sessionRepo.getTotalDurationForHobbyInRange(
        'h1',
        DateTime(2025, 3, 1),
        DateTime(2025, 3, 15),
      );
      expect(total, 75); // 30 + 45
    });

    test('getTotalDurationForHobbyInRange returns 0 when empty', () async {
      final total = await sessionRepo.getTotalDurationForHobbyInRange(
        'h1',
        DateTime(2025, 3, 1),
        DateTime(2025, 3, 31),
      );
      expect(total, 0);
    });
  });

  // ── GoalRepository ──

  group('GoalRepositoryImpl', () {
    setUp(() async {
      await hobbyRepo.createHobby(_hobby());
    });

    test('createGoal + getActiveGoals', () async {
      await goalRepo.createGoal(_goal());
      final list = await goalRepo.getActiveGoals();
      expect(list.length, 1);
      expect(list.first.targetDurationMinutes, 120);
    });

    test('getGoalsByHobby filters by hobbyId', () async {
      await hobbyRepo.createHobby(_hobby(id: 'h2', name: 'Piano'));
      await goalRepo.createGoal(_goal(id: 'g1', hobbyId: 'h1'));
      await goalRepo.createGoal(_goal(id: 'g2', hobbyId: 'h2'));

      final goals = await goalRepo.getGoalsByHobby('h1');
      expect(goals.length, 1);
      expect(goals.first.hobbyId, 'h1');
    });

    test('deactivateGoal removes from active list', () async {
      await goalRepo.createGoal(_goal());
      await goalRepo.deactivateGoal('g1');
      final list = await goalRepo.getActiveGoals();
      expect(list, isEmpty);
    });
  });
}
