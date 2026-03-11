# Design Document — v3.0.0 (Advanced)

## Overview

Advanced features: social sharing, AI suggestions, home screen widgets, and internationalization. Builds on v2.0.0 infrastructure (Firebase, notifications, SharedPreferences).

## Architecture Changes

### New Dependencies

```yaml
# Sharing
screenshot: ^3.0.0          # Capture widget as image
share_plus: ^7.2.0          # Already in v2.0.0

# AI / ML
tflite_flutter: ^0.10.0     # On-device inference

# Widgets
home_widget: ^0.4.0         # Android + iOS home screen widgets

# i18n
flutter_localizations:
  sdk: flutter
intl: ^0.19.0               # Already present
```

### Social Sharing

```dart
class ShareProgressCard {
  final String hobbyName;
  final String emoji;
  final Duration totalTime;
  final int streakDays;
  final Badge? recentBadge;
}

class GenerateShareCard {
  /// Renders a styled Widget to an image using screenshot package
  Future<File> call(ShareProgressCard data);
}
```

The share card is a custom `Widget` rendered off-screen via `screenshot` package, then shared via `share_plus`.

### AI Suggestions

On-device pattern analysis using simple heuristics (no ML model needed for v3.0.0 MVP):

```dart
class SuggestionEngine {
  /// Analyzes session timestamps to find optimal practice windows
  List<TimeWindow> suggestOptimalTimes(List<Session> sessions);

  /// Suggests complementary hobby categories based on existing hobbies
  List<String> suggestCategories(List<Hobby> hobbies);
}

class Suggestion {
  final String id;
  final SuggestionType type;    // optimalTime, newCategory
  final String title;
  final String description;
  final bool isDismissed;
}
```

Persist dismissed suggestions in SharedPreferences to avoid re-showing.

### Home Screen Widgets

Using `home_widget` package:

| Widget | Size | Content |
|--------|------|---------|
| Small | 2×1 | Today's total time + streak emoji |
| Medium | 4×2 | Top 3 hobbies with weekly time bars |

Data flow:
1. App writes widget data to `home_widget` shared storage on each session log
2. Widget reads from shared storage and renders natively
3. Background update via `home_widget.updateWidget()` on a 30-min schedule

### Internationalization

Using Flutter's built-in `l10n` system:

```
lib/
└── l10n/
    ├── app_en.arb          # English (base)
    ├── app_es.arb          # Spanish
    ├── app_fr.arb          # French
    ├── app_de.arb          # German
    ├── app_ja.arb          # Japanese
    └── app_hi.arb          # Hindi
```

Configure in `pubspec.yaml`:
```yaml
flutter:
  generate: true
```

And `l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### New BLoCs

| BLoC | Purpose |
|------|---------|
| `SuggestionCubit` | Load/dismiss suggestions |
| `LocaleCubit` | Manage language preference |

### New Screens

| Screen | Route | Description |
|--------|-------|-------------|
| `SharePreviewScreen` | dialog | Preview and share progress card |
| Language selector | in Settings | Dropdown for locale override |

### Settings Updates

Add to SettingsScreen:
- Language selector dropdown
- "Share Progress" button on hobby detail

### Timer Session Notes (Req 21)

Add optional `notes` field to Session entity:

```dart
class Session {
  // ... existing fields
  final String? notes;  // NEW — optional meeting/session note
}
```

The timer stop dialog gains an optional `TextField` for notes. The note is stored in the Drift `sessions` table (new nullable `notes` column via migration).

### Per-Hobby Stats Widget (Req 22)

New `HobbyWidgetProvider.kt` — a configurable Android widget that shows stats for a single hobby. Uses `home_widget` configurable widget support. The hobby ID is stored in widget-specific SharedPreferences keyed by `appWidgetId`.

### Dashboard Redesign (Req 23)

Replace the recent sessions list on the dashboard with per-hobby stat cards:

```dart
// Each active hobby gets a compact card showing:
// - Emoji + name
// - Weekly time
// - Streak count
```

The Hobbies list screen gains a history icon (`Icons.history`) on each hobby tile that navigates to a session history view filtered by that hobby.

### Goal Fixes (Req 24)

1. Goals screen resolves hobby name from `hobbyId` using the hobby map (same pattern as dashboard)
2. New `updateGoal` method in `GoalRepository` and Drift DAO
3. `AddGoalScreen` becomes `AddEditGoalScreen` — accepts optional `Goal` for edit mode
4. Goal list items become tappable → navigate to edit screen

### Interactive Charts (Req 25)

Enhance `fl_chart` usage:
- `PieChart`: set `showingSections` with `badgeWidget` for hobby names, enable `pieTouchData` with tooltip callback
- `BarChart`: enable `barTouchData` with tooltip showing hobby name + minutes
- `LineChart`: enable `lineTouchData` with tooltip showing date + minutes
- Add insight cards above charts: "Best Day" and "Most Active Hobby" computed from `StatsResult`
