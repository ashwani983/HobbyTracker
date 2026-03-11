# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
