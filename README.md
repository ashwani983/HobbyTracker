# 🎯 Hobby Tracker

A Flutter app to track, manage, and visualize your hobbies. Built with Clean Architecture and BLoC pattern, with local SQLite persistence.

![Flutter](https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- 🏷️ **Hobby Management** — Create, edit, and archive hobbies with categories and emoji icons
- ⏱️ **Session Logging** — Log sessions with duration, notes, and star ratings
- ⏲️ **Built-in Timer** — Stopwatch that persists across tab switches
- 🎯 **Goal Tracking** — Weekly/monthly goals with progress visualization
- 📊 **Statistics** — Bar, pie, and line charts with week/month/year views
- 📱 **Dashboard** — At-a-glance summary with recent activity
- 💾 **Offline-first** — Local SQLite storage via Drift

## Screenshots

_Coming soon_

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11.1
- Dart SDK ≥ 3.11.1

### Setup

```bash
git clone https://github.com/<your-username>/hobby-tracker.git
cd hobby-tracker
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Run

```bash
flutter run
```

### Test

```bash
flutter test
```

## Architecture

```
lib/
├── core/              # Error types, DI, constants
├── domain/            # Entities, repository interfaces, use cases
├── data/              # Drift database, repository implementations
├── presentation/      # BLoCs, screens, router, widgets
├── app.dart           # App widget with providers and router
└── main.dart          # Entry point
```

The app follows **Clean Architecture** with three layers:

| Layer | Purpose | Key Packages |
|-------|---------|-------------|
| Domain | Entities, use cases, repository contracts | — |
| Data | Drift DB, repository implementations | drift, sqlite3_flutter_libs |
| Presentation | BLoCs, screens, navigation | flutter_bloc, go_router, fl_chart |

## Tech Stack

- **State Management**: flutter_bloc / Cubit
- **Navigation**: go_router with ShellRoute
- **Database**: Drift (SQLite)
- **DI**: get_it
- **Charts**: fl_chart
- **Testing**: flutter_test, bloc_test, mocktail, glados (property-based)

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
