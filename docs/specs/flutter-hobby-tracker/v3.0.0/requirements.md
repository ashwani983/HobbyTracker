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

### Requirement 21: Timer Session Meeting Notes

**User Story:** As a user, I want to add a note/meeting description when logging a session from the timer, so I can remember what I worked on.

#### Acceptance Criteria

1. WHEN the timer stops and the save dialog appears, THE App SHALL show an optional text field for a meeting/session note
2. THE Session entity SHALL store an optional `notes` field
3. WHEN viewing session history, THE App SHALL display the note if present

### Requirement 22: Per-Hobby Stats Widget

**User Story:** As a user, I want a home screen widget that shows stats for a specific hobby I choose.

#### Acceptance Criteria

1. THE App SHALL provide a configurable home screen widget that displays stats for a single hobby
2. THE widget SHALL show hobby name, total time this week, and current streak
3. WHEN adding the widget, THE user SHALL be able to select which hobby to display
4. THE widget SHALL update when new sessions are logged

### Requirement 23: Per-Hobby Dashboard Stats

**User Story:** As a user, I want to see individual hobby stats on the dashboard instead of recent sessions.

#### Acceptance Criteria

1. THE dashboard SHALL display per-hobby stat cards showing weekly time and streak for each active hobby
2. THE App SHALL remove the recent sessions list from the dashboard
3. THE Hobbies tab SHALL include a history icon that navigates to session history for that hobby

### Requirement 24: Goal Bug Fixes and Editing

**User Story:** As a user, I want goals to show the hobby name and be editable after creation.

#### Acceptance Criteria

1. THE goals list SHALL display the hobby name for each goal instead of just the goal type
2. THE App SHALL allow editing an existing goal's target, dates, and type
3. WHEN a user taps a goal, THE App SHALL open an edit screen pre-filled with current values
4. THE GoalRepository SHALL support an `updateGoal` method

### Requirement 25: Interactive Charts and Insights

**User Story:** As a user, I want interactive charts with touch feedback and more insight types on the dashboard and stats screens.

#### Acceptance Criteria

1. THE pie chart (distribution) SHALL show hobby names as labels, not just percentages
2. All charts SHALL support touch interaction — tapping a bar/slice/point SHALL show a tooltip with details
3. THE stats screen SHALL include a "Best Day" and "Most Active Hobby" insight card
4. THE dashboard distribution chart SHALL display hobby names alongside percentages
