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
