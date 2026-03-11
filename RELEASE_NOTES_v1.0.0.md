# 🎯 Hobby Tracker v1.0.0

First release of Hobby Tracker — a Flutter app to track, manage, and visualize your hobbies.

## ✨ Highlights

- **5-tab app**: Dashboard, Hobbies, Timer, Goals, Stats
- **Full offline support** with local SQLite database
- **Clean Architecture** with BLoC pattern
- **26 property-based tests** covering domain logic

## 📋 What's Included

### Hobby Management
- Create hobbies with name, description, category, color
- Automatic emoji icons per category (⚽🎵🎨📚🎮🍳💪📷✍️🌟)
- Edit and archive hobbies with swipe-to-archive

### Session Tracking
- Log sessions with duration, date, notes, and 1–5 star rating
- Built-in stopwatch timer (persists across tab switches)
- Timer with start / pause / resume / stop / discard controls

### Goals
- Set weekly or monthly goals (session count or total minutes)
- Visual progress bars on goals screen

### Dashboard & Stats
- Active hobby count and weekly total at a glance
- Recent 5 sessions with hobby name and emoji
- Bar chart (time per hobby), pie chart (distribution), line chart (daily trend)
- Week / month / year period selector

## 🛠️ Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 📱 Tested On

- Pixel 6a — Android 16 (API 36)

## 📦 APK

Debug APK attached: `app-debug.apk`
