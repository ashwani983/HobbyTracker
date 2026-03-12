# Design Document — v4.0.0 (Connected)

## Overview

This document describes the technical design for v4.0.0 features layered on top of the existing Clean Architecture + BLoC codebase from v1–v3.

## New Dependencies

```yaml
dependencies:
  audioplayers: ^6.0.0            # alarm/notification sounds (Req 22)
  table_calendar: ^3.1.0          # calendar UI (Req 23)
  device_calendar: ^4.3.0         # native calendar sync (Req 23)
  flutter_heatmap_calendar: ^1.0.0 # heatmap view (Req 23)
  firebase_dynamic_links: ^6.0.0  # deep links for challenges (Req 24, 30)
  wear_plus: ^0.0.1               # Wear OS (Req 26)
  watch_connectivity: ^0.1.0      # watchOS (Req 26)
  record: ^5.1.0                  # audio recording (Req 29)
  just_audio: ^0.9.39             # audio playback (Req 29)
  audio_waveforms: ^1.0.5         # waveform visualization (Req 29)
  app_links: ^6.1.0               # deep linking (Req 30)
```

## Architecture Changes

### New Entities

```dart
class Routine {
  final String id;
  final String name;
  final List<RoutineStep> steps; // ordered hobbies with target durations
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class RoutineStep {
  final String hobbyId;
  final int targetMinutes;
}

class RoutineSchedule {
  final String id;
  final String routineId;
  final int dayOfWeek;     // 1=Mon, 7=Sun
  final TimeOfDay timeOfDay;
}

enum TimerMode { stopwatch, countdown, pomodoro }

class PomodoroConfig {
  final int focusMinutes;  // default 25
  final int breakMinutes;  // default 5
  final int longBreakMinutes; // default 15
  final int intervalsBeforeLongBreak; // default 4
}

class Challenge {
  final String id;
  final String? firebaseId;
  final String name;
  final String category;
  final int targetMinutes;
  final DateTime startDate;
  final DateTime endDate;
  final String inviteCode;
  final int participantLimit;
  final bool isActive;
}

class Partner {
  final String id;
  final String partnerUid;
  final String partnerDisplayName;
  final DateTime linkedAt;
  final bool isActive;
}

class AudioNote {
  final String id;
  final String sessionId;
  final String filePath;
  final int durationSeconds;
  final DateTime createdAt;
}
```

### New Database Tables (Drift)

```dart
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get hobbySequence => text()(); // JSON: [{hobbyId, targetMinutes}]
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class RoutineSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get routineId => integer().references(Routines, #id)();
  IntColumn get dayOfWeek => integer()();
  DateTimeColumn get timeOfDay => dateTime()();
}

class Challenges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firebaseId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get targetMinutes => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get inviteCode => text().unique()();
  IntColumn get participantLimit => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Partners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get partnerUid => text()();
  TextColumn get partnerDisplayName => text()();
  DateTimeColumn get linkedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class AudioNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  TextColumn get filePath => text()();
  IntColumn get durationSeconds => integer()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### New Repositories

| Repository | Purpose |
|---|---|
| `RoutineRepository` | CRUD for routines and schedules |
| `ChallengeRepository` | Local + Firestore challenge management |
| `PartnerRepository` | Partner linking via Firestore |
| `AudioNoteRepository` | Audio file storage and metadata |
| `CalendarRepository` | Device calendar read/write |

### New Use Cases

| Use Case | Requirement |
|---|---|
| `CreateRoutine`, `StartRoutine`, `ScheduleRoutine` | Req 21 |
| `StartCountdown`, `StartPomodoro`, `ConfigurePomodoro` | Req 22 |
| `GetCalendarSessions`, `SyncToCalendar`, `GetHeatmapData` | Req 23 |
| `CreateChallenge`, `JoinChallenge`, `GetLeaderboard` | Req 24 |
| `SendPartnerRequest`, `AcceptPartner`, `GetPartnerStats` | Req 25 |
| `SyncToWearable`, `ReceiveWearableTimer` | Req 26 |
| `RecordAudio`, `PlayAudio`, `DeleteAudio` | Req 29 |
| `HandleDeepLink` | Req 30 |

### New BLoCs / Cubits

| BLoC | State | Events |
|---|---|---|
| `RoutineBloc` | `RoutineInitial`, `RoutinesLoaded`, `RoutineRunning`, `RoutinePaused`, `RoutineCompleted` | `LoadRoutines`, `CreateRoutine`, `StartRoutine`, `PauseRoutine`, `AbortRoutine`, `AdvanceStep` |
| `TimerModeBloc` | Extends existing `TimerCubit` with mode, countdown remaining, pomodoro interval state | `SetMode`, `SetCountdownDuration`, `ConfigurePomodoro` |
| `CalendarBloc` | `CalendarLoaded`, `HeatmapLoaded` | `LoadMonth`, `LoadHeatmap`, `ToggleCalendarSync` |
| `ChallengeBloc` | `ChallengesLoaded`, `ChallengeDetail`, `LeaderboardLoaded` | `LoadChallenges`, `CreateChallenge`, `JoinChallenge`, `LeaveChallenge` |
| `PartnerBloc` | `PartnersLoaded`, `PartnerStatsLoaded` | `LoadPartners`, `SendRequest`, `AcceptRequest`, `RemovePartner` |
| `AudioNoteCubit` | `Idle`, `Recording`, `Playing` | via methods: `record()`, `stop()`, `play()`, `delete()` |

### New Screens

| Screen | Route | Description |
|---|---|---|
| `RoutineListScreen` | `/routines` | List/create routines |
| `RoutineRunnerScreen` | `/routines/:id/run` | Active routine execution with step progress |
| `CalendarScreen` | `/calendar` | Monthly calendar + heatmap toggle |
| `ChallengeListScreen` | `/challenges` | Browse/create challenges |
| `ChallengeDetailScreen` | `/challenges/:id` | Leaderboard + challenge info |
| `PartnerScreen` | `/partners` | Manage accountability partners |
| `AnalyticsScreen` | `/analytics` | Correlation matrix, consistency scores, monthly report |

### Accessibility Strategy

- Add `Semantics` widgets to all interactive elements
- Use `MediaQuery.textScaleFactor` guards for layout overflow
- Add pattern overlays to chart bars/segments
- Implement `FocusTraversalGroup` for keyboard navigation
- Add `SemanticsService.announce()` for timer updates
- High-contrast mode: override `ColorScheme` with WCAG AAA ratios

### Deep Linking Architecture

```
hobbytracker://dashboard       → /
hobbytracker://hobby/{id}      → /hobbies/:id
hobbytracker://timer/{hobbyId} → /timer?hobbyId=X
hobbytracker://challenge/{code}→ /challenges/join?code=X
```

- Use `app_links` package for Android App Links and iOS Universal Links
- `GoRouter` redirect handles deep link → internal route mapping
- Cold start: `getInitialLink()` → navigate after app init
- Warm start: `onLink` stream → navigate immediately

### Navigation Hub Architecture

```
Bottom Nav (5 tabs):
  Dashboard  →  /
  Hobbies    →  /hobbies
  Timer      →  /timer
  Calendar   →  /calendar
  More       →  /more

More Screen (hub):
  Routines   →  /routines    ← back → /more
  Goals      →  /goals       ← back → /more
  Stats      →  /stats       ← back → /more
  Settings   →  /settings    ← back → /more
    Export   →  /export      ← back → /settings
    Sync     →  /sync        ← back → /settings
    Badges   →  /badges      ← back → /settings
    Terms    →  /terms       ← back → /settings

Future (added to More, no nav changes):
  Analytics  →  /analytics
  Challenges →  /challenges
  Partners   →  /partners
```

- `MoreScreen` is a simple `ListView` of `ListTile` navigation items
- `AppShell._currentIndex` maps sub-paths to the More tab (index 4)
- All More sub-pages have explicit `leading` back button in `AppBar`
- Keeps bottom nav at 5 tabs regardless of feature count
