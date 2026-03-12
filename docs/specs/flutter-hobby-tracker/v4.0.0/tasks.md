# Implementation Plan — v4.0.0 (Connected)

## Overview

Builds on v1–v3 (Clean Architecture + BLoC + Drift). Adds routines, advanced timer, calendar, community, wearables, accessibility, analytics, audio notes, and deep linking. Estimated: 10 weeks (5 sprints).

## Sprint 1: Timer Modes, Deep Linking, Accessibility Foundation

- [x] 1. Advanced Timer Modes (Req 22)
  - [x] 1.1 Add `audioplayers` dependency
  - [x] 1.2 Create `TimerMode` enum (stopwatch, countdown, pomodoro) and `PomodoroConfig` entity
  - [x] 1.3 Extend `TimerCubit` with mode selection, countdown logic, and pomodoro cycle tracking
    - _Requirements: 22.1, 22.2, 22.3, 22.4, 22.5, 22.6_
  - [x] 1.4 Update timer screen UI with mode selector, remaining time display, interval counter
    - _Requirements: 22.6_
  - [x] 1.5 Persist pomodoro preferences in SharedPreferences
    - _Requirements: 22.7_
  - [x] 1.6 Ensure background tracking works for all modes
    - _Requirements: 22.8_

- [x] 2. Checkpoint — Timer Modes

- [x] 3. Deep Linking & URL Scheme (Req 30)
  - [x] 3.1 Add `app_links` dependency
  - [x] 3.2 Configure Android App Links and iOS Universal Links in manifests
  - [x] 3.3 Register `hobbytracker://` custom URL scheme
    - _Requirements: 30.1_
  - [x] 3.4 Implement `HandleDeepLink` use case mapping deep link routes to GoRouter paths
    - _Requirements: 30.2, 30.5_
  - [x] 3.5 Handle cold start (`getInitialLink`) and warm start (`onLink` stream) in `main.dart`
    - _Requirements: 30.3, 30.4_
  - [x] 3.6 Add `firebase_dynamic_links` for challenge invitations
    - _Requirements: 30.6_

- [x] 4. Checkpoint — Deep Linking

- [x] 5. Accessibility Foundation (Req 27)
  - [x] 5.1 Audit all screens and add `Semantics` labels to interactive elements
    - _Requirements: 27.1_
  - [x] 5.2 Add `MediaQuery.textScaleFactor` guards to prevent layout overflow at 200% scaling
    - _Requirements: 27.2_
  - [x] 5.3 Add non-color indicators (patterns/icons/labels) to charts, heatmap, and badges
    - _Requirements: 27.3_
  - [x] 5.4 Verify WCAG 2.1 AA contrast ratios in both themes
    - _Requirements: 27.4_
  - [x] 5.5 Implement `FocusTraversalGroup` for keyboard/switch navigation
    - _Requirements: 27.5_
  - [x] 5.6 Add screen reader announcements to timer at configurable intervals
    - _Requirements: 27.6_
  - [x] 5.7 Add high-contrast mode toggle in settings
    - _Requirements: 27.7_

- [x] 6. Checkpoint — Accessibility

## Sprint 2: Routines & Calendar

- [x] 7. Routines & Habit Chaining (Req 21)
  - [x] 7.1 Add `Routines` and `RoutineSchedules` Drift tables, run `build_runner`
    - _Requirements: 21.8_
  - [x] 7.2 Create `Routine`, `RoutineStep`, `RoutineSchedule` entities
  - [x] 7.3 Implement `RoutineRepository` with CRUD operations
  - [x] 7.4 Implement `CreateRoutine`, `StartRoutine`, `ScheduleRoutine` use cases
    - _Requirements: 21.1, 21.7_
  - [x] 7.5 Create `RoutineBloc` with states: Initial, Loaded, Running, Paused, Completed
    - _Requirements: 21.2, 21.5, 21.6_
  - [x] 7.6 Build `RoutineListScreen` (create/edit/delete routines, schedule picker)
    - _Requirements: 21.1, 21.7_
  - [x] 7.7 Build `RoutineRunnerScreen` (sequential timer, transition overlay, progress indicator)
    - _Requirements: 21.2, 21.3, 21.4, 21.5, 21.6_
  - [x] 7.8 Add `/routines` and `/routines/:id/run` routes to GoRouter
  - [x] 7.9 Add Routines to bottom nav or settings menu

- [x] 8. Checkpoint — Routines

- [ ] 9. Calendar Integration (Req 23)
  - [ ] 9.1 Add `table_calendar`, `device_calendar`, `flutter_heatmap_calendar` dependencies
  - [ ] 9.2 Implement `CalendarRepository` for device calendar read/write
    - _Requirements: 23.3, 23.4_
  - [ ] 9.3 Implement `GetCalendarSessions`, `SyncToCalendar`, `GetHeatmapData` use cases
  - [ ] 9.4 Create `CalendarBloc` with month loading and heatmap data
  - [ ] 9.5 Build `CalendarScreen` with monthly view (colored dots per hobby) and day detail
    - _Requirements: 23.1, 23.2_
  - [ ] 9.6 Add heatmap view toggle (12-month activity intensity grid)
    - _Requirements: 23.5, 23.6, 23.7_
  - [ ] 9.7 Add "Calendar Sync" toggle in settings
    - _Requirements: 23.3_
  - [ ] 9.8 Add `/calendar` route to GoRouter

- [ ] 10. Checkpoint — Calendar

## Sprint 3: Analytics & Audio Notes

- [ ] 11. Advanced Analytics & Insights (Req 28)
  - [ ] 11.1 Implement correlation matrix calculation (hobbies practiced on same day)
    - _Requirements: 28.1_
  - [ ] 11.2 Implement most productive day/time calculation
    - _Requirements: 28.2_
  - [ ] 11.3 Implement consistency score (0–100) per hobby over 30 days
    - _Requirements: 28.3_
  - [ ] 11.4 Add rolling averages (7-day, 30-day) to hobby detail screen
    - _Requirements: 28.4_
  - [ ] 11.5 Build monthly summary report view
    - _Requirements: 28.5_
  - [ ] 11.6 Build `AnalyticsScreen` with all metrics, calculated from local data
    - _Requirements: 28.6_
  - [ ] 11.7 Implement pinnable dashboard metrics (up to 3)
    - _Requirements: 28.7_
  - [ ] 11.8 Add `/analytics` route to GoRouter

- [ ] 12. Checkpoint — Analytics

- [ ] 13. Audio Notes (Req 29)
  - [ ] 13.1 Add `record`, `just_audio`, `audio_waveforms` dependencies
  - [ ] 13.2 Add `AudioNotes` Drift table, run `build_runner`
  - [ ] 13.3 Create `AudioNote` entity and `AudioNoteRepository`
  - [ ] 13.4 Implement `RecordAudio`, `PlayAudio`, `DeleteAudio` use cases
    - _Requirements: 29.1, 29.6_
  - [ ] 13.5 Create `AudioNoteCubit` with recording/playback states
  - [ ] 13.6 Add waveform recorder widget to session log/edit screen
    - _Requirements: 29.1, 29.2_
  - [ ] 13.7 Add playback widget with play/pause/seek controls
    - _Requirements: 29.3_
  - [ ] 13.8 Delete audio file when session is deleted
    - _Requirements: 29.4_
  - [ ] 13.9 Sync audio files to Firebase Storage when cloud sync enabled
    - _Requirements: 29.5_

- [ ] 14. Checkpoint — Audio Notes

## Sprint 4: Community Features

- [ ] 15. Community Challenges (Req 24)
  - [ ] 15.1 Add `Challenges` Drift table, run `build_runner`
  - [ ] 15.2 Create `Challenge` entity and `ChallengeRepository` (local + Firestore)
  - [ ] 15.3 Implement `CreateChallenge`, `JoinChallenge`, `GetLeaderboard` use cases
    - _Requirements: 24.1, 24.2, 24.3, 24.4_
  - [ ] 15.4 Create `ChallengeBloc` with real-time Firestore leaderboard listener
    - _Requirements: 24.6_
  - [ ] 15.5 Build `ChallengeListScreen` (browse, create, enter invite code)
    - _Requirements: 24.1, 24.3_
  - [ ] 15.6 Build `ChallengeDetailScreen` (leaderboard, progress, leave)
    - _Requirements: 24.4, 24.5, 24.8_
  - [ ] 15.7 Award special badge to top 3 when challenge ends
    - _Requirements: 24.5_
  - [ ] 15.8 Require cloud sync for participation
    - _Requirements: 24.7_
  - [ ] 15.9 Add `/challenges` and `/challenges/:id` routes

- [ ] 16. Checkpoint — Challenges

- [ ] 17. Accountability Partners (Req 25)
  - [ ] 17.1 Add `Partners` Drift table, run `build_runner`
  - [ ] 17.2 Create `Partner` entity and `PartnerRepository` (Firestore-backed)
  - [ ] 17.3 Implement `SendPartnerRequest`, `AcceptPartner`, `GetPartnerStats`, `RemovePartner` use cases
    - _Requirements: 25.1, 25.2, 25.3, 25.6_
  - [ ] 17.4 Create `PartnerBloc`
  - [ ] 17.5 Build `PartnerScreen` (invite, accept, view stats, remove)
    - _Requirements: 25.1, 25.2, 25.7_
  - [ ] 17.6 Add partner card to dashboard showing partner stats
    - _Requirements: 25.3, 25.4_
  - [ ] 17.7 Send notification when partner breaks 7+ day streak
    - _Requirements: 25.5_
  - [ ] 17.8 Add `/partners` route

- [ ] 18. Checkpoint — Partners

## Sprint 5: Wearable Integration & Final

- [ ] 19. Wearable Integration (Req 26)
  - [ ] 19.1 Add `wear_plus` and `watch_connectivity` dependencies
  - [ ] 19.2 Create Wear OS companion module with hobby list and timer UI
    - _Requirements: 26.1, 26.2, 26.3_
  - [ ] 19.3 Implement phone ↔ watch data sync layer
    - _Requirements: 26.2, 26.5_
  - [ ] 19.4 Add complication/tile showing today's time and streak
    - _Requirements: 26.4_
  - [ ] 19.5 Implement offline watch storage with reconnect sync
    - _Requirements: 26.6_
  - [ ] 19.6 Create watchOS companion with equivalent features
    - _Requirements: 26.7_

- [ ] 20. Checkpoint — Wearable

- [ ] 21. Final checkpoint — v4.0.0
  - [ ] 21.1 Run full test suite, fix regressions
  - [ ] 21.2 Update README and CHANGELOG for v4.0.0
  - [ ] 21.3 Build release APK
  - [ ] 21.4 Create GitHub release with tag `v4.0.0`
