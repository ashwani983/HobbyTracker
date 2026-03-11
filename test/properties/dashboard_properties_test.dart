import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/domain/repositories/session_repository.dart';
import 'package:hobby_tracker/domain/repositories/badge_repository.dart';
import 'package:hobby_tracker/domain/usecases/get_active_hobbies.dart';
import 'package:hobby_tracker/domain/usecases/get_recent_sessions.dart';
import 'package:hobby_tracker/domain/usecases/get_streak_count.dart';
import 'package:hobby_tracker/presentation/blocs/dashboard/dashboard_bloc.dart';

class MockGetActiveHobbies extends Mock implements GetActiveHobbies {}

class MockGetRecentSessions extends Mock implements GetRecentSessions {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockGetStreakCount extends Mock implements GetStreakCount {}

class MockBadgeRepository extends Mock implements BadgeRepository {}

void main() {
  late MockGetActiveHobbies getActiveHobbies;
  late MockGetRecentSessions getRecentSessions;
  late MockSessionRepository sessionRepo;
  late MockGetStreakCount getStreakCount;
  late MockBadgeRepository badgeRepo;

  setUp(() {
    getActiveHobbies = MockGetActiveHobbies();
    getRecentSessions = MockGetRecentSessions();
    sessionRepo = MockSessionRepository();
    getStreakCount = MockGetStreakCount();
    badgeRepo = MockBadgeRepository();
    when(() => getStreakCount()).thenAnswer((_) async => 0);
    when(() => badgeRepo.getUnlockedBadges()).thenAnswer((_) async => []);
  });

  List<Hobby> makeHobbies(int count) => List.generate(
        count,
        (i) => Hobby(
          id: 'h-$i',
          name: 'Hobby $i',
          category: 'Sports',
          iconName: 'i',
          color: 0,
          createdAt: DateTime(2024, 1, i + 1),
        ),
      );

  List<Session> makeSessions(int count) => List.generate(
        count,
        (i) => Session(
          id: 's-$i',
          hobbyId: 'h-0',
          date: DateTime.now().subtract(Duration(days: i)),
          durationMinutes: 30,
          createdAt: DateTime(2024),
        ),
      );

  // Feature: flutter-hobby-tracker, Property 11: Dashboard active hobby count
  blocTest<DashboardBloc, DashboardState>(
    'Property 11: active hobby count matches non-archived hobbies',
    setUp: () {
      when(() => getActiveHobbies()).thenAnswer((_) async => makeHobbies(3));
      when(() => getRecentSessions(any()))
          .thenAnswer((_) async => makeSessions(2));
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => makeSessions(2));
    },
    build: () => DashboardBloc(
      getActiveHobbies: getActiveHobbies,
      getRecentSessions: getRecentSessions,
      sessionRepository: sessionRepo,
      getStreakCount: getStreakCount,
      badgeRepository: badgeRepo,
    ),
    act: (bloc) => bloc.add(LoadDashboard()),
    verify: (bloc) {
      final state = bloc.state as DashboardLoaded;
      expect(state.activeHobbyCount, 3);
    },
  );

  // Feature: flutter-hobby-tracker, Property 12: Dashboard weekly total duration
  blocTest<DashboardBloc, DashboardState>(
    'Property 12: weekly total equals sum of session durations in week',
    setUp: () {
      final sessions = makeSessions(3); // 3 x 30 = 90 min
      when(() => getActiveHobbies()).thenAnswer((_) async => makeHobbies(1));
      when(() => getRecentSessions(any())).thenAnswer((_) async => sessions);
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
    },
    build: () => DashboardBloc(
      getActiveHobbies: getActiveHobbies,
      getRecentSessions: getRecentSessions,
      sessionRepository: sessionRepo,
      getStreakCount: getStreakCount,
      badgeRepository: badgeRepo,
    ),
    act: (bloc) => bloc.add(LoadDashboard()),
    verify: (bloc) {
      final state = bloc.state as DashboardLoaded;
      expect(state.weeklyTotalMinutes, 90);
    },
  );

  // Feature: flutter-hobby-tracker, Property 13: Dashboard recent sessions limit and order
  blocTest<DashboardBloc, DashboardState>(
    'Property 13: recent sessions limited to 5 and sorted desc',
    setUp: () {
      final sessions = makeSessions(5);
      when(() => getActiveHobbies()).thenAnswer((_) async => makeHobbies(1));
      when(() => getRecentSessions(any())).thenAnswer((_) async => sessions);
      when(() => sessionRepo.getSessionsInRange(any(), any()))
          .thenAnswer((_) async => sessions);
    },
    build: () => DashboardBloc(
      getActiveHobbies: getActiveHobbies,
      getRecentSessions: getRecentSessions,
      sessionRepository: sessionRepo,
      getStreakCount: getStreakCount,
      badgeRepository: badgeRepo,
    ),
    act: (bloc) => bloc.add(LoadDashboard()),
    verify: (bloc) {
      final state = bloc.state as DashboardLoaded;
      expect(state.recentSessions.length, lessThanOrEqualTo(5));
      for (var i = 0; i < state.recentSessions.length - 1; i++) {
        expect(
          state.recentSessions[i].date.isAfter(
                state.recentSessions[i + 1].date,
              ) ||
              state.recentSessions[i].date.isAtSameMomentAs(
                state.recentSessions[i + 1].date,
              ),
          isTrue,
        );
      }
    },
  );
}
