# Implementation Plan: Flutter Hobby Tracker

## Overview

Incremental implementation of the Flutter Hobby Tracker MVP using Clean Architecture and BLoC pattern. Tasks build on each other, starting with project setup and core domain, then data layer, then presentation, and finally wiring everything together.

## Tasks

- [x] 1. Project setup and core infrastructure
  - [x] 1.1 Create Flutter project and configure dependencies
    - Run `flutter create hobby_tracker` and configure `pubspec.yaml` with: flutter_bloc, go_router, drift, sqlite3_flutter_libs, get_it, injectable, fl_chart, flutter_slidable, intl, uuid, glados (dev), mocktail (dev), bloc_test (dev)
    - Create directory structure: `lib/core/`, `lib/data/`, `lib/domain/`, `lib/presentation/`
    - _Requirements: 7.1, 8.4_
  - [x] 1.2 Set up core error types and dependency injection
    - Create `lib/core/error/failures.dart` with `Failure`, `ValidationFailure`, `DatabaseFailure` classes
    - Create `lib/core/di/injection.dart` with GetIt service locator setup
    - Create `lib/core/constants/app_constants.dart` for shared constants (categories list, max rating, etc.)
    - _Requirements: 7.4_

- [x] 2. Domain layer — entities, repository interfaces, and use cases
  - [x] 2.1 Create domain entities and repository interfaces
    - Create `lib/domain/entities/hobby.dart`, `session.dart`, `goal.dart` with the entity classes from the design
    - Create `lib/domain/entities/goal_type.dart` enum
    - Create `lib/domain/repositories/hobby_repository.dart`, `session_repository.dart`, `goal_repository.dart` interfaces
    - _Requirements: 1.1, 2.1, 5.1_
  - [x] 2.2 Implement hobby use cases with validation
    - Create `lib/domain/usecases/create_hobby.dart` — validates non-empty name, creates hobby
    - Create `lib/domain/usecases/update_hobby.dart` — validates and updates hobby
    - Create `lib/domain/usecases/archive_hobby.dart` — archives a hobby
    - Create `lib/domain/usecases/get_active_hobbies.dart` — returns non-archived hobbies
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_
  - [x]* 2.3 Write property tests for hobby use cases
    - **Property 1: Hobby persistence round-trip**
    - **Property 2: Whitespace hobby name rejection**
    - **Property 3: Active hobbies list invariant**
    - **Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5, 1.6**
  - [x] 2.4 Implement session use cases with validation
    - Create `lib/domain/usecases/log_session.dart` — validates positive duration, rating in 1-5 if provided
    - Create `lib/domain/usecases/get_sessions_by_hobby.dart` — returns sessions sorted by date desc
    - Create `lib/domain/usecases/get_recent_sessions.dart` — returns N most recent sessions
    - _Requirements: 2.1, 2.2, 2.3, 2.5, 2.6_
  - [x]* 2.5 Write property tests for session use cases
    - **Property 4: Session persistence round-trip**
    - **Property 5: Non-positive session duration rejection**
    - **Property 6: Session rating out-of-range rejection**
    - **Property 7: Sessions sorted by date descending**
    - **Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5, 2.6**
  - [x] 2.6 Implement goal use cases with validation
    - Create `lib/domain/usecases/create_goal.dart` — validates positive target, valid date range
    - Create `lib/domain/usecases/get_active_goals.dart` — returns active goals with progress
    - Create `lib/domain/usecases/deactivate_goal.dart` — deactivates a goal
    - Create `lib/domain/usecases/get_goal_progress.dart` — calculates progress percentage
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.7_
  - [x]* 2.7 Write property tests for goal use cases
    - **Property 14: Goal persistence round-trip**
    - **Property 15: Non-positive goal target rejection**
    - **Property 16: Invalid goal date range rejection**
    - **Property 17: Goal progress percentage calculation**
    - **Property 18: Goal completion on target met**
    - **Property 19: Goal deactivation removes from active list**
    - **Validates: Requirements 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7**
  - [x] 2.8 Implement stats use case
    - Create `lib/domain/usecases/get_stats.dart` — aggregates per-hobby totals, proportions, and daily totals for a date range; excludes hobbies with no sessions
    - _Requirements: 6.1, 6.2, 6.3, 6.5_
  - [x]* 2.9 Write property tests for stats use case
    - **Property 20: Stats per-hobby aggregation and proportions**
    - **Property 21: Stats daily aggregation**
    - **Property 22: Stats excludes hobbies with no sessions**
    - **Validates: Requirements 6.1, 6.2, 6.3, 6.5**

- [x] 3. Checkpoint — Domain layer
  - All tests pass. ✅

- [x] 4. Data layer — Drift database and repository implementations
  - [x] 4.1 Create Drift database schema and DAOs
    - Create `lib/data/datasources/database.dart` with HobbyTable, SessionTable, GoalTable
    - Create DAOs for each table with query methods matching the data source interfaces
    - Run Drift code generation (`dart run build_runner build`)
    - _Requirements: 7.1, 7.2_
  - [x] 4.2 Implement repository classes
    - Create `lib/data/repositories/hobby_repository_impl.dart` — maps between Drift data and domain entities
    - Create `lib/data/repositories/session_repository_impl.dart`
    - Create `lib/data/repositories/goal_repository_impl.dart`
    - Each repository wraps database errors in `DatabaseFailure`
    - _Requirements: 1.6, 2.4, 5.6, 7.3, 7.4_
  - [x] 4.3 Write unit tests for repository implementations
    - Test data mapping between Drift models and domain entities
    - Test error handling wraps database exceptions in DatabaseFailure
    - **Property 23: Database failure preserves state**
    - _Requirements: 7.3, 7.4_
  - [x] 4.4 Register all dependencies in GetIt
    - Wire up database, data sources, repositories, and use cases in `lib/core/di/injection.dart`
    - _Requirements: 7.1_

- [x] 5. Checkpoint — Data layer
  - All tests pass. ✅

- [x] 6. Presentation layer — BLoCs
  - [x] 6.1 Implement HobbyListBloc and HobbyDetailBloc
    - Create `lib/presentation/blocs/hobby_list/hobby_list_bloc.dart` with LoadHobbies, CreateHobby, ArchiveHobby events
    - Create `lib/presentation/blocs/hobby_detail/hobby_detail_bloc.dart` with LoadHobbyDetail event
    - Handle loading, loaded, empty, and error states
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_
  - [x] 6.2 Implement SessionBloc
    - Create `lib/presentation/blocs/session/session_bloc.dart` with LogSession event
    - Handle initial, saving, saved, and error states
    - _Requirements: 2.1, 2.2, 2.5, 2.6_
  - [x] 6.3 Implement TimerCubit
    - Create `lib/presentation/blocs/timer/timer_cubit.dart` with start, pause, resume, stop, discard methods
    - Use `Stopwatch` internally; manage states: Initial, Running, Paused, Stopped
    - Emit elapsed time updates via a periodic stream while running
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7_
  - [x]* 6.4 Write property tests for TimerCubit
    - **Property 8: Timer pause/resume round-trip**
    - **Property 9: Timer stop yields correct duration**
    - **Property 10: Timer discard resets state**
    - **Validates: Requirements 3.2, 3.3, 3.4, 3.5**
  - [x] 6.5 Implement DashboardBloc
    - Create `lib/presentation/blocs/dashboard/dashboard_bloc.dart` with LoadDashboard event
    - Aggregate active hobby count, weekly total, recent 5 sessions
    - Handle loaded, empty, and error states
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_
  - [x]* 6.6 Write property tests for DashboardBloc aggregation
    - **Property 11: Dashboard active hobby count**
    - **Property 12: Dashboard weekly total duration**
    - **Property 13: Dashboard recent sessions limit and order**
    - **Validates: Requirements 4.1, 4.2, 4.3**
  - [x] 6.7 Implement GoalBloc and StatsBloc
    - Create `lib/presentation/blocs/goal/goal_bloc.dart` with LoadGoals, CreateGoal, DeactivateGoal events
    - Create `lib/presentation/blocs/stats/stats_bloc.dart` with LoadStats, ChangeTimePeriod events
    - Handle loading, loaded, empty, and error states
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.7, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

- [x] 7. Checkpoint — BLoCs
  - All tests pass. ✅

- [x] 8. Presentation layer — Screens and navigation
  - [x] 8.1 Set up go_router and bottom navigation shell
    - Create `lib/presentation/router/app_router.dart` with named routes from the design
    - Create `lib/presentation/widgets/app_shell.dart` with bottom navigation bar (Dashboard, Hobbies, Timer, Goals, Stats)
    - _Requirements: 8.1, 8.2, 8.4_
  - [x] 8.2 Implement Dashboard screen
    - Create `lib/presentation/screens/dashboard_screen.dart`
    - Display active hobby count, weekly total, recent 5 sessions
    - Show empty state when no data exists
    - _Requirements: 4.1, 4.2, 4.3, 4.5_
  - [x] 8.3 Implement Hobbies List and Hobby Detail screens
    - Create `lib/presentation/screens/hobbies_list_screen.dart` — list of active hobbies with slidable delete
    - Create `lib/presentation/screens/hobby_detail_screen.dart` — hobby info with session list
    - _Requirements: 1.4, 1.5, 2.3, 8.3_
  - [x] 8.4 Implement Add/Edit Hobby screen
    - Create `lib/presentation/screens/add_edit_hobby_screen.dart` — form with name, description, category, icon, color fields
    - Show inline validation errors for empty name
    - _Requirements: 1.1, 1.2, 1.3_
  - [x] 8.5 Implement Log Session screen
    - Create `lib/presentation/screens/log_session_screen.dart` — form with date, duration, notes, rating fields
    - Show inline validation errors for invalid duration and rating
    - _Requirements: 2.1, 2.2, 2.5, 2.6_
  - [x] 8.6 Implement Timer screen
    - Create `lib/presentation/screens/timer_screen.dart` — hobby selector, start/pause/resume/stop/discard buttons, elapsed time display
    - On stop, prompt to save as session
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_
  - [x] 8.7 Implement Goals screen and Add Goal screen
    - Create `lib/presentation/screens/goals_screen.dart` — list of active goals with progress bars
    - Create `lib/presentation/screens/add_goal_screen.dart` — form with hobby, type, target, date range
    - Show inline validation errors
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.7_
  - [x] 8.8 Implement Stats screen with charts
    - Create `lib/presentation/screens/stats_screen.dart` — bar chart, pie chart, line chart using fl_chart
    - Time period selector (week, month, year)
    - Show empty state when no data
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

- [x] 9. Integration and wiring
  - [x] 9.1 Wire up main.dart and app entry point
    - Create `lib/main.dart` — initialize DI, database, and run app
    - Create `lib/app.dart` — MaterialApp.router with go_router and BLoC providers
    - _Requirements: 7.2, 8.1_
  - [x] 9.2 Write widget tests for key screens
    - Test Dashboard empty state and loaded state
    - Test Hobby form validation (empty name shows error)
    - Test Session form validation (invalid duration/rating shows error)
    - _Requirements: 1.2, 2.2, 2.6, 4.5_

- [x] 10. Create README for local testing
  - Create `README.md` with: project overview, prerequisites (Flutter SDK, Dart), setup instructions (`flutter pub get`, `dart run build_runner build`), run instructions (`flutter run`), test instructions (`flutter test`), project structure overview
  - _Requirements: all_

- [x] 11. Final checkpoint
  - All 26 tests pass. `flutter analyze lib/` — 0 issues. App tested on Pixel 6a (Android 16). ✅

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- All tasks complete including previously optional 4.3 and 9.2
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties from the design document
- Unit tests validate specific examples and edge cases
- Drift code generation (`build_runner`) must be run after creating/modifying table definitions
