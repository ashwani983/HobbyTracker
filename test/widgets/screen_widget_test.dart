import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hobby_tracker/domain/entities/hobby.dart';
import 'package:hobby_tracker/domain/entities/session.dart';
import 'package:hobby_tracker/l10n/app_localizations.dart';
import 'package:hobby_tracker/presentation/blocs/hobby_list/hobby_list_bloc.dart';
import 'package:hobby_tracker/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:hobby_tracker/presentation/blocs/theme/theme_cubit.dart';
import 'package:hobby_tracker/presentation/blocs/update/update_cubit.dart';
import 'package:hobby_tracker/presentation/screens/hobbies_list_screen.dart';
import 'package:hobby_tracker/presentation/screens/dashboard_screen.dart';

// Mocks
class MockHobbyListBloc extends MockBloc<HobbyListEvent, HobbyListState>
    implements HobbyListBloc {}

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

class MockUpdateCubit extends MockCubit<UpdateState> implements UpdateCubit {}

void main() {
  final testHobby = Hobby(
    id: 'h1',
    name: 'Guitar',
    category: 'Music',
    iconName: 'interests',
    color: 0xFF2196F3,
    createdAt: DateTime(2025, 1, 1),
  );

  final testSession = Session(
    id: 's1',
    hobbyId: 'h1',
    date: DateTime(2025, 3, 10),
    durationMinutes: 45,
    rating: 4,
    createdAt: DateTime(2025, 3, 10),
  );

  // ── HobbiesListScreen ──

  group('HobbiesListScreen', () {
    late MockHobbyListBloc bloc;

    setUp(() => bloc = MockHobbyListBloc());

    Widget buildSubject() => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<HobbyListBloc>.value(
            value: bloc,
            child: const HobbiesListScreen(),
          ),
        );

    testWidgets('shows loading indicator', (tester) async {
      when(() => bloc.state).thenReturn(HobbyListLoading());
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message', (tester) async {
      when(() => bloc.state).thenReturn(HobbyListEmpty());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('No hobbies yet. Add one!'), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      when(() => bloc.state).thenReturn(const HobbyListError('DB error'));
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('DB error'), findsOneWidget);
    });

    testWidgets('shows hobby list with name and category', (tester) async {
      when(() => bloc.state).thenReturn(HobbyListLoaded([testHobby]));
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('Guitar'), findsOneWidget);
      expect(find.text('Music'), findsOneWidget);
    });

    testWidgets('shows emoji for category', (tester) async {
      when(() => bloc.state).thenReturn(HobbyListLoaded([testHobby]));
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('🎵'), findsOneWidget);
    });

    testWidgets('has FAB to add hobby', (tester) async {
      when(() => bloc.state).thenReturn(HobbyListEmpty());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  // ── DashboardScreen ──

  group('DashboardScreen', () {
    late MockDashboardBloc dashBloc;
    late MockHobbyListBloc hobbyBloc;
    late MockThemeCubit themeCubit;
    late MockUpdateCubit updateCubit;

    setUp(() {
      dashBloc = MockDashboardBloc();
      hobbyBloc = MockHobbyListBloc();
      themeCubit = MockThemeCubit();
      updateCubit = MockUpdateCubit();
      when(() => themeCubit.state).thenReturn(ThemeMode.light);
      when(() => updateCubit.state).thenReturn(UpdateInitial());
    });

    Widget buildSubject() => MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<DashboardBloc>.value(value: dashBloc),
              BlocProvider<HobbyListBloc>.value(value: hobbyBloc),
              BlocProvider<ThemeCubit>.value(value: themeCubit),
              BlocProvider<UpdateCubit>.value(value: updateCubit),
            ],
            child: const DashboardScreen(),
          ),
        );

    testWidgets('shows loading indicator', (tester) async {
      when(() => dashBloc.state).thenReturn(DashboardLoading());
      when(() => hobbyBloc.state).thenReturn(HobbyListLoading());
      await tester.pumpWidget(buildSubject());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty message', (tester) async {
      when(() => dashBloc.state).thenReturn(DashboardEmpty());
      when(() => hobbyBloc.state).thenReturn(HobbyListEmpty());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('No data yet. Add a hobby to get started!'), findsOneWidget);
    });

    testWidgets('shows summary card with counts', (tester) async {
      when(() => dashBloc.state).thenReturn(const DashboardLoaded(
        activeHobbyCount: 3,
        weeklyTotalMinutes: 150,
        recentSessions: [],
      ));
      when(() => hobbyBloc.state).thenReturn(HobbyListLoaded([testHobby]));
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
      expect(find.text('Active Hobbies'), findsOneWidget);
      expect(find.text('2h 30m'), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
    });

    testWidgets('shows per-hobby stat cards', (tester) async {
      when(() => dashBloc.state).thenReturn(DashboardLoaded(
        activeHobbyCount: 1,
        weeklyTotalMinutes: 45,
        recentSessions: [testSession],
        hobbyStats: [HobbyStats(hobbyId: 'h1', name: 'Guitar', category: 'Music', weeklyMinutes: 45)],
      ));
      when(() => hobbyBloc.state).thenReturn(HobbyListLoaded([testHobby]));
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Guitar'), findsOneWidget);
      expect(find.text('🎵'), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      when(() => dashBloc.state).thenReturn(const DashboardError('fail'));
      when(() => hobbyBloc.state).thenReturn(HobbyListEmpty());
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      expect(find.text('fail'), findsOneWidget);
    });
  });
}
