# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-03-12

### Added

- **Internationalization (i18n)**: 6 languages (English, Spanish, French, German, Japanese, Hindi), device locale detection, manual override in settings
- **Social Sharing**: Generate styled progress cards with hobby stats and badges, share via system share sheet from hobby detail and badge screens
- **AI Suggestions**: On-device suggestion engine — neglected hobbies, streak motivation, variety tips — dismissible cards on dashboard
- **Home Screen Widgets**: 3 Android widgets — Today's Progress (time + streak), Top Hobbies (top 3 weekly), Single Hobby (per-hobby stats) — with distinct names and descriptions
- **Timer Session Notes**: Optional notes text field in timer save dialog
- **Goal Editing**: Tap goals to edit target, dates, and type; goals display hobby name
- **Interactive Charts**: Touch tooltips on bar, pie, and daily activity charts; hobby name labels on pie chart slices
- **Insight Cards**: Best Day and Most Active Hobby cards above stats charts
- **Dashboard Redesign**: Per-hobby stat cards with weekly time replace recent sessions list
- **Session History**: History icon on hobbies list for quick navigation to hobby detail

### Changed

- Daily activity chart changed from line to bar chart with day-of-week labels
- Dashboard no longer shows recent sessions (moved to hobby detail)
- GoalRepository now supports updateGoal method
- Widget update triggers on every session log for real-time data

### Fixed

- Home screen widget data not updating (SharedPreferences mismatch)
- Widget showing n-1 session data (dashboard reload on session save)
- Goals not showing hobby name

## [2.0.0] - 2026-03-11

### Added

- **Dark Mode**: Light, dark, and system theme modes with persistent preference via SharedPreferences
- **Streaks & Badges**: 14 badge types (streak, milestone, time, explorer), consecutive-day streak tracking, unlock popup after session log
- **Reminders & Notifications**: Per-hobby reminders with time picker and weekday selector, notification tap navigates to timer with hobby pre-selected
- **Photo Attachments**: Camera and gallery image picker (up to 5 per session), photo thumbnails on session list, full-screen viewer with swipe and pinch-to-zoom
- **Data Export**: CSV and PDF export with date range filter, share sheet integration
- **Cloud Sync**: Firebase Auth with Google Sign-In, Firestore sync (upload/download hobbies, sessions, goals), auto-sync toggle
- **Onboarding**: 3-page intro PageView for new users with skip/next/get started
- **Settings Screen**: Theme toggle, cloud sync, export, badges, terms, check for updates, about with version info
- **In-App Update Checker**: Fetches latest GitHub release, semver comparison, dashboard banner with Update/Later, 24h dismiss, force-check in Settings
- **Dashboard Enhancements**: Current streak count, recent badge display in summary card

### Changed

- Database schema v2 with migration from v1 (new tables: user_badges, reminders; new columns: photo_paths)
- Upgraded flutter_local_notifications to v20.0.0
- Dashboard AppBar simplified — settings gear replaces individual action buttons
- Navigation uses context.push() for screens that need reload on return

### Fixed

- Hobby detail page not refreshing after logging a session
- Goals page not refreshing after adding a goal
- Stats page truncating hobby names to 4 characters

## [1.0.0] - 2026-03-11

### Added

- **Hobby Management**: Create, edit, and archive hobbies with name, description, category, color, and emoji icons
- **Session Logging**: Log practice sessions with duration, date, optional notes, and 1–5 star rating
- **Built-in Timer**: Stopwatch timer with start/pause/resume/stop/discard — persists across tab switches
- **Goal Tracking**: Set weekly or monthly goals (session count or total minutes) with progress bars
- **Dashboard**: At-a-glance view with active hobby count, weekly total, and 5 most recent sessions with hobby names
- **Statistics**: Bar chart (time per hobby), pie chart (distribution), and line chart (daily activity) with week/month/year period selector
- **Category Emojis**: Automatic emoji icons per category — ⚽ Sports, 🎵 Music, 🎨 Art, 📚 Reading, 🎮 Gaming, 🍳 Cooking, 💪 Fitness, 📷 Photography, ✍️ Writing, 🌟 Other
- **Local Persistence**: SQLite database via Drift with full offline support
- **Clean Architecture**: Domain / Data / Presentation layers with BLoC pattern
- **Property-Based Tests**: 26 tests using glados, mocktail, and bloc_test covering domain logic, timer, dashboard, and stats
- **Bottom Navigation**: 5-tab layout — Dashboard, Hobbies, Timer, Goals, Stats
- **Material 3**: Modern Material Design 3 theming with dynamic color
