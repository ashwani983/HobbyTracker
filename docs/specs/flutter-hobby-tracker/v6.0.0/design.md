# Design Document — v6.0.0 (Intelligence)

## Overview

This document describes the technical design for v6.0.0 features layered on top of the existing Clean Architecture + BLoC codebase from v1–v5. The focus is on on-device intelligence — all ML/analytics run locally.

## New Dependencies

```yaml
dependencies:
  # Req 39: Smart Scheduling
  # (built on existing calendar + session repos)

  # Req 40: Mood & Energy Tracking
  # (built on existing session system + Drift)

  # Req 41: Focus Score
  # (built on existing session/timer system)

  # Req 42: Predictive Goals
  # (built on existing goal system + analytics)

  # Req 43: Smart Reminders
  # (built on existing reminder system)

  # Req 44: Data Visualization 2.0
  sankey_chart: ^0.1.0            # Sankey diagram
  radar_chart: ^1.0.0             # radar/spider chart
  screenshot: ^3.0.0              # chart export as PNG
```

## Database Changes (Schema v7 → v8)

### New Tables

```dart
class MoodEntryTable extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get preMood => integer().nullable()();   // 1-5
  IntColumn get postMood => integer().nullable()();  // 1-5
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class FocusScoreTable extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  IntColumn get score => integer()();               // 0-100
  IntColumn get pauseCount => integer()();
  RealColumn get durationRatio => real()();          // actual/typical
  RealColumn get timeOfDayScore => real()();         // 0-1
  RealColumn get pomodoroScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SmartScheduleTable extends Table {
  TextColumn get id => text()();
  TextColumn get hobbyId => text()();
  IntColumn get dayOfWeek => integer()();            // 1=Mon..7=Sun
  IntColumn get suggestedHour => integer()();        // 0-23
  IntColumn get suggestedMinute => integer()();      // 0-59
  RealColumn get confidence => real()();             // 0-1
  DateTimeColumn get generatedAt => dateTime()();
  BoolColumn get accepted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Migration v7 → v8

```sql
CREATE TABLE mood_entries (
  id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  pre_mood INTEGER,
  post_mood INTEGER,
  created_at INTEGER NOT NULL
);

CREATE TABLE focus_scores (
  id TEXT PRIMARY KEY,
  session_id TEXT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  score INTEGER NOT NULL,
  pause_count INTEGER NOT NULL,
  duration_ratio REAL NOT NULL,
  time_of_day_score REAL NOT NULL,
  pomodoro_score REAL,
  created_at INTEGER NOT NULL
);

CREATE TABLE smart_schedules (
  id TEXT PRIMARY KEY,
  hobby_id TEXT NOT NULL,
  day_of_week INTEGER NOT NULL,
  suggested_hour INTEGER NOT NULL,
  suggested_minute INTEGER NOT NULL,
  confidence REAL NOT NULL,
  generated_at INTEGER NOT NULL,
  accepted INTEGER NOT NULL DEFAULT 0
);
```

## Architecture Changes

### New Entities

```dart
class MoodEntry {
  final String id;
  final String sessionId;
  final int? preMood;     // 1-5
  final int? postMood;    // 1-5
  final DateTime createdAt;
}

class FocusScore {
  final String id;
  final String sessionId;
  final int score;         // 0-100
  final int pauseCount;
  final double durationRatio;
  final double timeOfDayScore;
  final double? pomodoroScore;
}

class SmartScheduleSlot {
  final String id;
  final String hobbyId;
  final int dayOfWeek;
  final int suggestedHour;
  final int suggestedMinute;
  final double confidence;
  final bool accepted;
}

class GoalPrediction {
  final String goalId;
  final double completionProbability;  // 0-1
  final DateTime projectedCompletionDate;
  final String? catchUpSuggestion;
}

class HobbyRadarMetrics {
  final String hobbyId;
  final double timeScore;        // 0-1 normalized
  final double consistencyScore; // 0-1
  final double focusScore;       // 0-1
  final double moodLift;         // 0-1 normalized
  final double streakScore;      // 0-1 normalized
}
```

### New Repositories

```dart
abstract class MoodRepository {
  Future<void> saveMood(MoodEntry entry);
  Future<MoodEntry?> getMoodForSession(String sessionId);
  Future<List<MoodEntry>> getMoodsInRange(DateTime start, DateTime end);
  Future<double> getMoodLiftForHobby(String hobbyId);
  Future<Map<int, double>> getWeeklyMoodAverages();  // day -> avg mood
}

abstract class FocusScoreRepository {
  Future<void> saveScore(FocusScore score);
  Future<FocusScore?> getScoreForSession(String sessionId);
  Future<List<FocusScore>> getScoresInRange(DateTime start, DateTime end);
  Future<double> getAverageScoreForHobby(String hobbyId);
  Future<int> getConsecutiveHighScoreCount(String hobbyId, int threshold);
}

abstract class SmartScheduleRepository {
  Future<void> saveSchedule(List<SmartScheduleSlot> slots);
  Future<List<SmartScheduleSlot>> getCurrentSchedule();
  Future<void> acceptSlot(String slotId);
}
```

### New Services

```dart
/// Analyzes session patterns to generate optimal schedule
class ScheduleAnalyzer {
  /// Requires 30+ sessions. Returns suggested weekly slots per hobby.
  List<SmartScheduleSlot> generateSchedule(
    List<Session> sessions,
    List<CalendarEvent> calendarEvents,
  );
}

/// Calculates focus score for a completed session
class FocusScoreCalculator {
  /// Weights: duration ratio (30%), pause count (25%),
  /// time of day (25%), pomodoro completion (20%)
  FocusScore calculate(Session session, List<Session> historicalSessions);
}

/// Predicts goal completion based on current pace
class GoalPredictor {
  GoalPrediction predict(Goal goal, List<Session> sessions);
}

/// Determines optimal reminder times from behavior patterns
class ReminderAnalyzer {
  /// Returns best reminder time per hobby based on session history
  Map<String, TimeOfDay> getOptimalReminderTimes(
    List<Session> sessions,
    List<bool> dismissHistory,
  );
}
```

### New BLoCs

```dart
// Mood tracking
class MoodBloc extends Bloc<MoodEvent, MoodState> {
  // Events: SavePreMood, SavePostMood, LoadMoodTrends, LoadWeeklySummary
  // States: MoodInitial, MoodLoaded (trends, weeklyAvg, hobbyMoodLifts)
}

// Focus scoring
class FocusCubit extends Cubit<FocusState> {
  // States: FocusInitial, FocusLoaded (score, trend, consecutiveHigh)
}

// Smart scheduling
class SmartScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  // Events: GenerateSchedule, AcceptSlot, DismissSlot
  // States: ScheduleInitial, ScheduleGenerated (slots), ScheduleInsufficient (need more sessions)
}

// Goal predictions
class GoalPredictionCubit extends Cubit<GoalPredictionState> {
  // States: PredictionInitial, PredictionLoaded (predictions per goal)
}
```

### New Screens

```
lib/presentation/screens/
├── wellness_screen.dart          # Mood trends, weekly summary, hobby mood lifts
├── focus_screen.dart             # Focus score trends, tips, Deep Focus badge progress
├── smart_schedule_screen.dart    # Suggested weekly schedule, accept/dismiss slots
├── advanced_viz_screen.dart      # Sankey, radar, comparative charts
```

### Focus Score Algorithm

```
score = (durationScore * 0.30) + (pauseScore * 0.25) + (timeScore * 0.25) + (pomodoroScore * 0.20)

durationScore:
  ratio = actual_duration / avg_duration_for_hobby
  if ratio in [0.8, 1.2]: 100
  elif ratio in [0.5, 0.8) or (1.2, 1.5]: linear interpolation 50-100
  else: max(0, 50 - abs(ratio - 1) * 50)

pauseScore:
  0 pauses: 100
  1 pause: 85
  2 pauses: 70
  3+ pauses: max(0, 70 - (pauses - 2) * 15)

timeScore:
  Calculate user's peak hours from historical sessions
  If session within peak window: 100
  Within 1 hour of peak: 75
  Within 2 hours: 50
  Otherwise: 25

pomodoroScore (only if Pomodoro mode):
  completed_cycles / planned_cycles * 100
  If not Pomodoro: redistribute weight to other factors (0.375, 0.3125, 0.3125)
```

### Smart Scheduling Algorithm

```
For each hobby with 30+ sessions:
  1. Build histogram: sessions per (dayOfWeek, hourBucket)
     hourBucket = hour rounded to nearest hour
  2. Normalize to probability distribution
  3. Pick top 3 (day, hour) slots with highest probability
  4. Check against device calendar for conflicts
  5. If conflict, shift to next-best non-conflicting slot
  6. Assign confidence = probability / max_probability
  7. Store as SmartScheduleSlot
```

### Goal Prediction Algorithm

```
For each active goal:
  1. elapsed_days = today - goal.startDate
  2. total_days = goal.endDate - goal.startDate
  3. time_fraction = elapsed_days / total_days
  4. progress_fraction = current_progress / target
  5. pace_ratio = progress_fraction / time_fraction
  6. probability = clamp(pace_ratio * 0.7 + trend_factor * 0.3, 0, 1)
     trend_factor: slope of last 7 days progress (positive = bonus)
  7. projected_date = startDate + (elapsed_days / progress_fraction)
  8. If probability < 0.5:
     deficit = target - current_progress
     remaining_days = total_days - elapsed_days
     daily_needed = deficit / remaining_days
     catchUpSuggestion = "Add {daily_needed} min/day to stay on track"
```

## UI Flow

### Mood Tracking Flow

```
Timer Stop → Save Session Dialog
  ├── [Optional] Pre-mood prompt (if enabled, shown at timer start)
  ├── Duration, notes, rating (existing)
  └── [Optional] Post-mood prompt: "How do you feel now?" + 5 emoji buttons
      └── Save → MoodEntry created alongside Session
```

### Smart Schedule Flow

```
More → Smart Schedule
  ├── "Generating..." (if first time or weekly refresh)
  ├── Weekly grid showing suggested slots per hobby
  │   ├── Each slot: hobby name, time, confidence bar
  │   ├── Tap → "Accept" (creates reminder) or "Dismiss"
  │   └── Conflict indicator if overlaps with calendar
  └── "Need 30+ sessions" message if insufficient data
```

### Advanced Viz Flow

```
More → Analytics → Advanced Viz tab
  ├── Sankey: days → hobbies → goals (interactive, tap to highlight)
  ├── Radar: select hobby → 5-axis chart
  ├── Compare: pick 2 hobbies → side-by-side bar/line charts
  └── Export button → PNG share sheet
```
