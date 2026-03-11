# Design Document — v2.0.0 (Enhanced)

## Overview

This document describes the technical design for v2.0.0 features layered on top of the existing Clean Architecture + BLoC codebase from v1.0.0.

## Architecture Changes

### New Entities

```dart
class Badge {
  final String id;
  final String title;
  final String emoji;
  final BadgeType type;       // streak, milestone, time, explorer
  final int threshold;
  final DateTime? unlockedAt;
}

enum BadgeType { streak, milestone, time, explorer }

class Reminder {
  final String id;
  final String hobbyId;
  final TimeOfDay time;
  final List<int> weekDays;   // 1=Mon, 7=Sun
  final bool isActive;
}
```

### New Database Tables

```sql
CREATE TABLE user_badges (
  id          TEXT PRIMARY KEY,
  badge_type  TEXT NOT NULL,
  hobby_id    TEXT,
  unlocked_at TEXT NOT NULL,
  FOREIGN KEY (hobby_id) REFERENCES hobbies(id) ON DELETE SET NULL
);

CREATE TABLE reminders (
  id        TEXT PRIMARY KEY,
  hobby_id  TEXT NOT NULL,
  time      TEXT NOT NULL,
  week_days TEXT NOT NULL,       -- comma-separated: "1,3,5"
  is_active INTEGER NOT NULL DEFAULT 1,
  FOREIGN KEY (hobby_id) REFERENCES hobbies(id) ON DELETE CASCADE
);
```

### Sessions Table Update

Add `photo_paths` column (TEXT, nullable, comma-separated local file paths).

### New Repositories

| Repository | Methods |
|-----------|---------|
| `BadgeRepository` | `getAll()`, `getUnlocked()`, `unlock(badge)` |
| `ReminderRepository` | `getByHobby(id)`, `create(reminder)`, `update(reminder)`, `delete(id)` |

### New Use Cases

| Use Case | Description |
|----------|-------------|
| `CheckBadges` | Evaluates all badge criteria against current stats, returns newly unlocked |
| `GetStreakCount` | Calculates current consecutive-day streak |
| `ScheduleReminder` | Creates reminder + schedules local notification |
| `CancelReminder` | Cancels notification + deactivates reminder |
| `AttachPhotos` | Saves images to app directory, updates session |
| `ExportCsv` | Generates CSV from all data in date range |
| `ExportPdf` | Generates PDF report with charts |
| `SyncToCloud` | Uploads local data to Firestore |
| `SyncFromCloud` | Merges remote data into local DB |

### New BLoCs

| BLoC | Events | States |
|------|--------|--------|
| `BadgeBloc` | `LoadBadges`, `CheckNewBadges` | `Loading`, `Loaded(all, unlocked)`, `NewBadgeUnlocked(badge)` |
| `ReminderBloc` | `LoadReminders`, `CreateReminder`, `ToggleReminder`, `DeleteReminder` | `Loading`, `Loaded(reminders)`, `Error` |
| `ThemeCubit` | — | `ThemeState(mode: light/dark/system)` |
| `AuthBloc` | `SignIn`, `SignOut` | `Unauthenticated`, `Authenticated(user)`, `Error` |
| `SyncBloc` | `StartSync`, `StopSync` | `Idle`, `Syncing`, `Synced`, `Error` |

### New Screens

| Screen | Route | Description |
|--------|-------|-------------|
| `OnboardingScreen` | `/onboarding` | 3-page intro with PageView |
| `SettingsScreen` | `/settings` | Theme, notifications, sync, export, about |
| `BadgesScreen` | `/badges` | Grid of earned + locked badges |
| `SessionPhotosViewer` | dialog | Full-screen image viewer |

### New Dependencies

```yaml
# Notifications
flutter_local_notifications: ^17.0.0

# Firebase
firebase_core: ^2.24.0
firebase_auth: ^4.16.0
cloud_firestore: ^4.14.0

# Image
image_picker: ^1.0.5

# Export
csv: ^6.0.0
pdf: ^3.10.0
share_plus: ^7.2.0

# Preferences
shared_preferences: ^2.2.2
```

### Navigation Changes

- Add 6th bottom nav tab "Profile/Settings" OR move Settings to app bar menu
- Add `/onboarding` route guarded by shared_preferences flag
- Add `/badges` route from settings or dashboard

### Theme System

```dart
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;
  ThemeCubit(this._prefs) : super(_loadInitial(_prefs));

  void setTheme(ThemeMode mode) {
    _prefs.setString('theme', mode.name);
    emit(mode);
  }

  static ThemeMode _loadInitial(SharedPreferences p) {
    final s = p.getString('theme');
    return ThemeMode.values.firstWhere((m) => m.name == s, orElse: () => ThemeMode.system);
  }
}
```

### Badge Definitions

| Badge | Type | Emoji | Threshold |
|-------|------|-------|-----------|
| 3-Day Streak | streak | 🔥 | 3 days |
| Week Warrior | streak | ⚡ | 7 days |
| Monthly Master | streak | 🏆 | 30 days |
| Century Club | streak | 💎 | 100 days |
| First Step | milestone | 👣 | 1 session |
| Getting Serious | milestone | 💪 | 10 sessions |
| Dedicated | milestone | 🎯 | 50 sessions |
| Centurion | milestone | 🏅 | 100 sessions |
| First Hour | time | ⏰ | 1 hour |
| Time Investor | time | 📈 | 10 hours |
| Master of Time | time | ⌛ | 100 hours |
| Explorer | explorer | 🧭 | 3 hobbies |
| Adventurer | explorer | 🗺️ | 5 hobbies |
| Renaissance | explorer | 🎭 | 10 hobbies |

### Cloud Sync Strategy

- Conflict resolution: last-write-wins based on `updatedAt` timestamp
- Add `updatedAt` column to hobbies, sessions, goals tables
- Sync on app launch (if enabled) and on each write operation
- Queue writes when offline, flush on reconnect

### Export Format

- CSV: one file per entity type (hobbies.csv, sessions.csv, goals.csv) zipped together
- PDF: single document with summary page + per-hobby breakdown with mini charts

### In-App Update Checker

```dart
class AppUpdateService {
  static const _repo = 'ashwani983/HobbyTracker';
  static const _apiUrl = 'https://api.github.com/repos/$_repo/releases/latest';

  /// Returns release info if a newer version exists, null otherwise.
  Future<GitHubRelease?> checkForUpdate(String currentVersion);
}

class GitHubRelease {
  final String tagName;     // e.g. "v2.0.0"
  final String name;        // release title
  final String body;        // release notes markdown
  final String htmlUrl;     // browser link to release page
}
```

- **UpdateCubit** — states: `UpdateInitial`, `UpdateChecking`, `UpdateAvailable(release)`, `UpdateNotAvailable`, `UpdateError`
- Version comparison uses `package_info_plus` to read running version, then compares semver components
- "Dismiss for 24h" persisted via `SharedPreferences` key `last_update_dismiss`
- Settings screen shows current version + "Check for updates" button
- On launch, auto-check runs only if last dismiss was >24h ago
