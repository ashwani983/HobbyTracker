# Design Document — v5.0.0 (Platform & Monetization)

## Overview

This document describes the technical design for v5.0.0 features layered on top of the existing Clean Architecture + BLoC codebase from v1–v4.

## New Dependencies

```yaml
dependencies:
  # Req 31: Web & Desktop
  responsive_framework: ^1.1.0    # responsive breakpoints
  window_manager: ^0.3.8          # desktop window control

  # Req 32: AI Coaching
  tflite_flutter: ^0.10.4         # on-device inference

  # Req 33: Premium / Freemium
  purchases_flutter: ^6.0.0       # RevenueCat SDK

  # Req 34: Custom Themes
  google_fonts: ^6.1.0            # font family options
  flex_color_picker: ^3.4.0       # color picker UI

  # Req 35: Integration Plugins
  spotify_sdk: ^2.3.0             # Spotify integration
  health: ^10.0.0                 # Google Fit / Apple Health
  strava_client: ^1.0.0           # Strava API

  # Req 36: Offline-First
  connectivity_plus: ^6.0.0       # network state monitoring

  # Req 37: Advanced Goals
  # (built on existing goal system + drift)

  # Req 38: Feedback
  in_app_review: ^2.0.9           # native app store review prompt
```

## Architecture Changes

### New Entities

```dart
enum SubscriptionTier { free, premium }

class UserSubscription {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isTrialActive;
}

class CustomTheme {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String fontFamily;
  final String iconStyle; // outline, filled, rounded
}

class ThemePack {
  final String id;
  final String name;
  final CustomTheme theme;
  final bool isBuiltIn;
}

class CoachMessage {
  final String id;
  final String content;
  final bool isFromCoach;
  final DateTime timestamp;
}

class SyncOperation {
  final String id;
  final String type;       // push, pull, conflict
  final String dataType;   // hobbies, sessions, goals, media, themes
  final String status;     // success, failed, pending
  final DateTime timestamp;
  final String? errorMessage;
}

class PluginConfig {
  final String pluginId;   // spotify, google_fit, strava, calendar
  final bool isEnabled;
  final Map<String, dynamic> settings;
}

enum GoalType { weekly, monthly, yearly, cumulative, streakBased }

class MilestoneGoal {
  final String id;
  final String hobbyId;
  final List<int> checkpointMinutes; // e.g., [600, 3000, 6000]
  final int currentCheckpointIndex;
}

class FeedbackEntry {
  final String id;
  final String type;       // bug, feature
  final String content;
  final String appVersion;
  final String deviceInfo;
  final DateTime submittedAt;
}
```

### New Database Tables (Drift)

```dart
class UserSubscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tier => text()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  BoolColumn get isTrialActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
}

class CustomThemes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get primaryColor => integer()();
  IntColumn get secondaryColor => integer()();
  IntColumn get backgroundColor => integer()();
  TextColumn get fontFamily => text()();
  TextColumn get iconStyle => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class SyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get dataType => text()();
  TextColumn get status => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get errorMessage => text().nullable()();
}

class PluginConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pluginId => text().unique()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get settings => text()(); // JSON
  DateTimeColumn get updatedAt => dateTime()();
}

class MilestoneGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get hobbyId => text()();
  TextColumn get checkpoints => text()(); // JSON array of minutes
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

class FeedbackEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get content => text()();
  TextColumn get appVersion => text()();
  TextColumn get deviceInfo => text()();
  DateTimeColumn get submittedAt => dateTime()();
}
```

### New Repositories

| Repository | Purpose |
|---|---|
| `SubscriptionRepository` | RevenueCat + local subscription state |
| `CustomThemeRepository` | Theme CRUD, import/export as code string |
| `CoachRepository` | On-device inference, message history |
| `SyncAuditRepository` | Sync operation log (last 100 entries) |
| `PluginRepository` | Plugin config, enable/disable, sync |
| `FeedbackRepository` | Submit to Firestore, fetch community board |

### New Use Cases

| Use Case | Requirement |
|---|---|
| `CheckSubscription`, `PurchaseSubscription`, `RestorePurchase` | Req 33 |
| `CreateCustomTheme`, `ApplyTheme`, `ShareTheme`, `ImportTheme` | Req 34 |
| `GenerateBriefing`, `AskCoach`, `GetCoachAlerts` | Req 32 |
| `QueueOfflineWrite`, `ResolveConflict`, `GetSyncAudit` | Req 36 |
| `EnablePlugin`, `SyncPlugin`, `GetPluginData` | Req 35 |
| `CreateMilestoneGoal`, `CheckMilestone`, `GetGoalTimeline` | Req 37 |
| `SubmitFeedback`, `GetCommunityBoard`, `UpvoteRequest` | Req 38 |

### New BLoCs / Cubits

| BLoC | Purpose |
|---|---|
| `SubscriptionCubit` | Manages tier state, gates premium features |
| `CustomThemeCubit` | Extends `ThemeCubit` with custom theme support |
| `CoachBloc` | Chat messages, daily briefing, proactive alerts |
| `SyncStatusCubit` | Real-time sync indicator (synced/syncing/offline/error) |
| `PluginBloc` | Plugin enable/disable, sync status per plugin |
| `AdvancedGoalBloc` | Extends `GoalBloc` with milestone and streak-based goals |
| `FeedbackBloc` | Submit feedback, load community board |

### New Screens

| Screen | Route | Description |
|---|---|---|
| `CoachScreen` | `/coach` | Chat interface with AI coach |
| `SubscriptionScreen` | `/subscription` | Tier comparison, purchase, restore |
| `ThemeEditorScreen` | `/themes` | Create/apply/share custom themes |
| `PluginSettingsScreen` | `/plugins` | Enable/configure integrations |
| `SyncAuditScreen` | `/sync/audit` | View last 100 sync operations |
| `FeedbackScreen` | `/feedback` | Submit feedback form |
| `CommunityBoardScreen` | `/community` | View/upvote feature requests |
| `GoalTimelineScreen` | `/goals/:id/timeline` | Projected completion visualization |

### Responsive Layout Strategy

```
< 600px (mobile):
  - Single column, bottom navigation bar
  - Current layout preserved

600–800px (small tablet):
  - Two-column where applicable (list + detail)
  - Bottom navigation bar

> 800px (tablet/desktop):
  - Collapsible NavigationRail replaces BottomNavigationBar
  - Two or three column layout
  - Persistent side navigation

> 1200px (desktop):
  - Three-column: nav rail + list + detail
  - Dashboard shows all widgets side-by-side
```

Implementation: `LayoutBuilder` in `AppShell` switches between `NavigationBar` and `NavigationRail` based on width.

### Subscription Gating Architecture

```dart
class FeatureGate {
  static bool canAccess(SubscriptionTier tier, Feature feature) {
    if (tier == SubscriptionTier.premium) return true;
    return _freeFeatures.contains(feature);
  }

  static const _freeFeatures = {
    Feature.basicTimer,
    Feature.basicDashboard,
    Feature.basicCharts,
    Feature.lightDarkTheme,
    Feature.localStorage,
  };
}
```

- Wrap premium screens with `BlocBuilder<SubscriptionCubit>` that shows upgrade prompt for free users
- Hobby creation checks count limit (5 for free tier)
- Expired premium: hobbies beyond 5 become read-only via `isReadOnly` flag

### Offline-First Sync Architecture

```
Write Operation → Local DB (immediate) → Sync Queue (pending)
                                              ↓
                              Connectivity restored → Process queue
                                              ↓
                              Conflict? → last-write-wins (updatedAt)
                                              ↓
                              Log to SyncOperations table
```

- `connectivity_plus` monitors network state
- `SyncStatusCubit` emits: `synced`, `syncing`, `offline`, `error`
- App bar shows colored dot indicator
- Selective sync: per-data-type toggle stored in `SharedPreferences`

### Plugin Architecture

```dart
abstract class HobbyTrackerPlugin {
  String get id;
  String get name;
  String get description;
  Future<void> initialize();
  Future<void> onSessionStart(String hobbyId);
  Future<void> onSessionEnd(String hobbyId, Duration duration);
  Future<Map<String, dynamic>> fetchData();
  Future<void> dispose();
}
```

Each built-in plugin implements this interface. Plugin configs stored in `PluginConfigs` table. Future community plugins can be loaded dynamically.
