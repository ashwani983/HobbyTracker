# Implementation Plan — v2.0.0 (Enhanced)

## Overview

Builds on v1.0.0 (Clean Architecture + BLoC). Adds gamification, notifications, media, export, dark mode, cloud sync, onboarding, and settings. Estimated: 6 weeks.

## Tasks

- [x] 1. Foundation — schema migration, new dependencies, shared preferences
  - [x] 1.1 Add new dependencies to pubspec.yaml
    - flutter_local_notifications, firebase_core, firebase_auth, cloud_firestore, image_picker, csv, pdf, share_plus, shared_preferences
    - _Requirements: 10.1, 11.1, 12.1, 13.2, 14.1_
  - [x] 1.2 Database migration — add new tables and columns
    - Add `user_badges` table, `reminders` table
    - Add `photo_paths` column to sessions table
    - Add `updated_at` column to hobbies, sessions, goals tables
    - Run `build_runner` to regenerate
    - _Requirements: 9.7, 11.2, 14.3_
  - [x] 1.3 Add shared preferences initialization to DI
    - _Requirements: 13.2, 15.3_

- [x] 2. Dark mode and theme system
  - [x] 2.1 Implement ThemeCubit with light/dark/system modes
    - Persist preference in SharedPreferences
    - _Requirements: 13.1, 13.2, 13.3_
  - [x] 2.2 Update App widget to use ThemeCubit
    - Provide both light and dark ThemeData
    - _Requirements: 13.4_
  - [x] 2.3 Verify all screens render correctly in dark mode
    - Charts, cards, forms, navigation
    - _Requirements: 13.4_

- [x] 3. Checkpoint — Theme

- [x] 4. Streaks and badges
  - [x] 4.1 Create Badge entity, BadgeType enum, and BadgeRepository
    - _Requirements: 9.1, 9.6_
  - [x] 4.2 Implement GetStreakCount use case
    - Query sessions grouped by date, count consecutive days
    - _Requirements: 9.1_
  - [x] 4.3 Implement CheckBadges use case
    - Evaluate streak, milestone, time, and explorer thresholds
    - Return list of newly unlocked badges
    - _Requirements: 9.2, 9.3, 9.4, 9.5_
  - [x] 4.4 Implement BadgeBloc
    - Events: LoadBadges, CheckNewBadges
    - States: Loading, Loaded, NewBadgeUnlocked
    - _Requirements: 9.6_
  - [x] 4.5 Create BadgesScreen with grid of earned/locked badges
    - _Requirements: 9.6_
  - [x] 4.6 Show badge popup when new badge unlocked after session log
    - _Requirements: 9.2, 9.3, 9.4, 9.5_
  - [x] 4.7 Write tests for streak calculation and badge unlocking
    - _Requirements: 9.1, 9.2_

- [x] 5. Checkpoint — Badges

- [x] 6. Reminders and notifications
  - [x] 6.1 Create Reminder entity and ReminderRepository
    - _Requirements: 10.1_
  - [x] 6.2 Implement NotificationService wrapper
    - Initialize flutter_local_notifications
    - Schedule/cancel by ID
    - _Requirements: 10.2_
  - [x] 6.3 Implement ScheduleReminder and CancelReminder use cases
    - _Requirements: 10.1, 10.4_
  - [x] 6.4 Implement ReminderBloc
    - _Requirements: 10.1, 10.4_
  - [x] 6.5 Add reminder UI to hobby detail screen
    - Time picker, weekday selector, toggle
    - _Requirements: 10.1_
  - [x] 6.6 Handle notification tap — navigate to timer with hobby pre-selected
    - _Requirements: 10.3_
  - [x] 6.7 Request notification permissions on first setup
    - _Requirements: 10.5_

- [x] 7. Checkpoint — Reminders

- [x] 8. Photo/media log
  - [x] 8.1 Implement AttachPhotos use case
    - Use image_picker, save to app documents directory
    - Update session with photo paths
    - _Requirements: 11.1, 11.2_
  - [x] 8.2 Update LogSessionScreen with image picker
    - Camera and gallery options, up to 5 images
    - _Requirements: 11.1_
  - [x] 8.3 Display photo thumbnails on session detail
    - _Requirements: 11.2_
  - [x] 8.4 Full-screen image viewer on tap
    - _Requirements: 11.3_
  - [x] 8.5 Delete photos when session is deleted
    - _Requirements: 11.4_

- [x] 9. Checkpoint — Media

- [x] 10. Export data
  - [x] 10.1 Implement ExportCsv use case
    - Generate CSV for hobbies, sessions, goals with date range filter
    - _Requirements: 12.1, 12.4_
  - [x] 10.2 Implement ExportPdf use case
    - Generate PDF report with summary stats
    - _Requirements: 12.2_
  - [x] 10.3 Add export options to settings screen with share sheet
    - _Requirements: 12.3_

- [x] 11. Checkpoint — Export

- [x] 12. Cloud sync (Firebase)
  - [x] 12.1 Configure Firebase project and add config files
    - _Requirements: 14.1_
  - [x] 12.2 Implement AuthBloc with Google and email sign-in
    - _Requirements: 14.1_
  - [x] 12.3 Implement SyncToCloud and SyncFromCloud use cases
    - Last-write-wins conflict resolution on updatedAt
    - _Requirements: 14.2, 14.3_
  - [x] 12.4 Implement SyncBloc
    - Auto-sync on launch and after writes when enabled
    - _Requirements: 14.2, 14.5_
  - [x] 12.5 Add sign-in and sync toggle to settings
    - _Requirements: 14.4_
  - [x]* 12.6 Write tests for sync conflict resolution
    - _Requirements: 14.3_

- [x] 13. Checkpoint — Cloud Sync

- [x] 14. Onboarding and settings
  - [x] 14.1 Create OnboardingScreen with 3-page PageView
    - _Requirements: 15.1, 15.2_
  - [x] 14.2 Guard onboarding with SharedPreferences flag
    - _Requirements: 15.2, 15.3_
  - [x] 14.3 Create SettingsScreen
    - Theme toggle, notification prefs, sync toggle, export, about/version
    - _Requirements: 16.1, 16.2, 16.3_
  - [x] 14.4 Update navigation — add settings route
    - _Requirements: 16.1_

- [x] 15. Checkpoint — Onboarding & Settings

- [x] 16. In-App Update Checker
  - [x] 16.1 Add `http` and `package_info_plus` dependencies
    - _Requirements: 17.1, 17.5_
  - [x] 16.2 Create GitHubRelease model and AppUpdateService
    - Fetch latest release from GitHub API, parse tag, compare semver
    - _Requirements: 17.1, 17.5, 17.6_
  - [x] 16.3 Implement UpdateCubit
    - States: Initial, Checking, Available, NotAvailable, Error
    - 24h dismiss logic via SharedPreferences
    - _Requirements: 17.2, 17.4_
  - [x] 16.4 Add update banner/dialog to app shell or dashboard
    - Show release title + notes summary, "Update" and "Later" buttons
    - _Requirements: 17.2, 17.3, 17.4_
  - [x] 16.5 Add "Check for updates" button and version display to Settings
    - _Requirements: 17.7_
  - [x] 16.6 Open browser to GitHub release page on "Update" tap
    - _Requirements: 17.3_

- [ ] 17. Polish and integration
  - [ ] 17.1 Update dashboard to show current streak and recent badge
  - [ ] 17.2 Add streak indicator to hobby detail screen
  - [ ] 17.3 Update README and CHANGELOG for v2.0.0

- [ ] 18. Final checkpoint
  - Ensure all tests pass, all analysis clean, ask user if questions arise.

## Notes

- Tasks marked with `*` are optional test tasks
- Firebase setup requires a Firebase project — user must provide google-services.json / GoogleService-Info.plist
- Notification permissions differ between iOS and Android — test on both
- Database migration must preserve existing v1.0.0 data
