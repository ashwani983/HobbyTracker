# 🎯 Hobby Tracker

A Flutter app to track, manage, and visualize your hobbies. Built with Clean Architecture and BLoC pattern, with local SQLite persistence and optional Firebase cloud sync.

![Flutter](https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

### Core
- 🏷️ **Hobby Management** — Create, edit, and archive hobbies with categories and emoji icons
- ⏱️ **Session Logging** — Log sessions with duration, notes, star ratings, and photos
- ⏲️ **Built-in Timer** — Stopwatch that persists across tab switches
- 🎯 **Goal Tracking** — Weekly/monthly goals with progress visualization
- 📊 **Statistics** — Bar, pie, and line charts with week/month/year views
- 📱 **Dashboard** — Streak count, recent badge, weekly summary, recent activity

### v2.0.0
- 🌙 **Dark Mode** — Light, dark, and system theme with persistent preference
- 🔥 **Streaks & Badges** — 14 badge types, consecutive-day streaks, unlock popups
- 🔔 **Reminders** — Per-hobby reminders with weekday selection, notification tap → timer
- 📷 **Photo Attachments** — Camera/gallery photos on sessions, full-screen viewer
- 📤 **Export** — CSV and PDF reports with date range filter and share sheet
- ☁️ **Cloud Sync** — Firebase Auth (Google sign-in) + Firestore sync
- 🚀 **Onboarding** — 3-page intro for new users
- ⚙️ **Settings** — Theme, sync, export, badges, updates, about
- 🔄 **In-App Updates** — Checks GitHub releases, shows banner, opens download page

### v3.0.0
- 🌍 **Internationalization** — 6 languages (EN/ES/FR/DE/JA/HI), manual override in settings
- 📣 **Social Sharing** — Share progress cards with hobby stats and badges via system share sheet
- 🤖 **AI Suggestions** — On-device suggestion engine for neglected hobbies, streaks, and variety
- 📱 **Home Screen Widgets** — 3 Android widgets: Today's Progress, Top Hobbies, Single Hobby
- 📝 **Timer Notes** — Optional meeting/session notes when saving from timer
- 🎯 **Goal Editing** — Goals show hobby name, tap to edit target/dates/type
- 📊 **Interactive Charts** — Touch tooltips on all charts, hobby name labels on pie chart
- 💡 **Insight Cards** — Best Day and Most Active Hobby cards on stats screen
- 🏠 **Dashboard Redesign** — Per-hobby stat cards replace recent sessions list
- 🕐 **Session History** — History icon on hobbies list for quick access

## Screenshots

_Coming soon_

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11.1
- Dart SDK ≥ 3.11.1

### Setup

```bash
git clone https://github.com/ashwani983/HobbyTracker.git
cd HobbyTracker/hobby_tracker
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Firebase (optional — required for Cloud Sync)

Cloud sync requires a Firebase project. The config files are gitignored, so you need to set up your own:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Configure Firebase for the project:
   ```bash
   flutterfire configure --project=YOUR_PROJECT_ID
   ```
   This generates:
   - `lib/firebase_options.dart`
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

4. In Firebase Console → **Authentication** → **Sign-in method**, enable **Google** provider
5. Add your Android debug SHA-1 fingerprint:
   ```bash
   cd android && ./gradlew signingReport
   ```
   Copy the SHA-1 from the `debug` variant and add it in Firebase Console → **Project Settings** → **Your apps** → **Android app** → **SHA certificate fingerprints**

6. Enable **Cloud Firestore** in Firebase Console → **Firestore Database** → Create database (start in test mode or configure security rules)

### Run

```bash
flutter run
```

### Test

```bash
flutter test
```

## Deep Links

The app supports the `hobbytracker://` URL scheme:

| Link | Destination |
|------|-------------|
| `hobbytracker://dashboard` | Dashboard |
| `hobbytracker://hobby/{id}` | Hobby detail |
| `hobbytracker://timer/{hobbyId}` | Timer with hobby pre-selected |

Test via adb:
```bash
adb shell am start -a android.intent.action.VIEW -d "hobbytracker://dashboard" com.hobbytracker.app
```

## Architecture

```
lib/
├── core/              # Error types, DI, constants, services
├── domain/            # Entities, repository interfaces, use cases, services
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
- **Cloud**: Firebase Auth, Cloud Firestore
- **DI**: get_it
- **Charts**: fl_chart
- **Notifications**: flutter_local_notifications
- **Export**: csv, pdf, share_plus
- **Widgets**: home_widget (Android home screen widgets)
- **i18n**: flutter_localizations, intl
- **Testing**: flutter_test, bloc_test, mocktail, glados (property-based)

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
