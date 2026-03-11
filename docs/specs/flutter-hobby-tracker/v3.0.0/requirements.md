# Requirements Document — v3.0.0 (Advanced)

## Introduction

Version 3.0.0 adds social features, AI-powered suggestions, home screen widgets, and multi-language support. Builds on v2.0.0 (which includes cloud sync, badges, reminders, media, export, and dark mode).

## Requirements

### Requirement 17: Social / Sharing

**User Story:** As a user, I want to share my progress with friends, so that I can celebrate achievements and stay accountable.

#### Acceptance Criteria

1. WHEN a user taps "Share" on a hobby or badge, THE App SHALL generate a styled progress card image
2. THE progress card SHALL include hobby name, emoji, total time, streak count, and recent badge
3. WHEN the card is generated, THE App SHALL present the system share sheet
4. THE App SHALL support sharing to any app that accepts images (social media, messaging)

### Requirement 18: AI Suggestions

**User Story:** As a user, I want the app to suggest new hobbies or optimal practice times based on my patterns.

#### Acceptance Criteria

1. WHEN a user has logged at least 20 sessions, THE App SHALL analyze patterns and suggest optimal practice times
2. THE App SHALL suggest new hobby categories based on the user's existing hobbies and common pairings
3. Suggestions SHALL appear on the dashboard as dismissible cards
4. THE App SHALL use on-device inference only — no data sent to external servers
5. WHEN a user dismisses a suggestion, THE App SHALL not show the same suggestion again

### Requirement 19: Home Screen Widgets

**User Story:** As a user, I want to see my hobby stats on my home screen without opening the app.

#### Acceptance Criteria

1. THE App SHALL provide a small widget showing today's total time and current streak
2. THE App SHALL provide a medium widget showing top 3 hobbies with time this week
3. WHEN a user taps a widget, THE App SHALL open to the dashboard
4. Widgets SHALL update at least every 30 minutes
5. THE App SHALL support both Android (home_widget) and iOS (WidgetKit) widgets

### Requirement 20: Multi-language (i18n)

**User Story:** As a user, I want to use the app in my preferred language.

#### Acceptance Criteria

1. THE App SHALL support English, Spanish, French, German, Japanese, and Hindi
2. All user-facing strings SHALL be externalized using Flutter's intl/l10n system
3. THE App SHALL detect the device locale and use the matching language by default
4. THE App SHALL allow manual language override in settings
5. Date and number formatting SHALL respect the selected locale
