# Requirements Document — v2.0.0 (Enhanced)

## Introduction

Version 2.0.0 builds on the MVP with gamification, notifications, media attachments, data export, dark mode, cloud sync, onboarding, and a polished design system. All v1.0.0 features remain intact.

## Glossary

- **Streak**: Consecutive days with at least one logged session for any hobby
- **Badge**: An achievement unlocked by meeting specific criteria (streak length, session count, total hours)
- **Reminder**: A scheduled local notification prompting the user to practice a hobby
- **Cloud Sync**: Firebase-backed backup and multi-device synchronization of all user data
- **Onboarding**: A first-launch walkthrough introducing the app's features

## Requirements

### Requirement 9: Streaks & Badges

**User Story:** As a user, I want to earn badges and track streaks, so that I stay motivated to practice my hobbies consistently.

#### Acceptance Criteria

1. WHEN a user logs at least one session on consecutive days, THE App SHALL calculate and display the current streak count
2. WHEN a streak reaches a threshold (3, 7, 30, 100 days), THE App SHALL unlock the corresponding badge and show a congratulatory popup
3. WHEN a user reaches session milestones (1, 10, 50, 100 sessions), THE App SHALL unlock the corresponding badge
4. WHEN a user accumulates time milestones (1h, 10h, 100h total), THE App SHALL unlock the corresponding badge
5. WHEN a user tracks 3, 5, or 10 different hobbies, THE App SHALL unlock explorer badges
6. THE App SHALL display all earned and locked badges on a dedicated Badges screen
7. THE App SHALL persist badge data to the local database and sync to cloud when enabled

### Requirement 10: Reminders

**User Story:** As a user, I want to set reminders for my hobbies, so that I don't forget to practice.

#### Acceptance Criteria

1. WHEN a user configures a reminder for a hobby with a time and weekdays, THE App SHALL schedule local notifications for those days
2. WHEN a scheduled reminder fires, THE App SHALL display a notification with the hobby name and a motivational message
3. WHEN a user taps a reminder notification, THE App SHALL navigate to the timer screen with the hobby pre-selected
4. WHEN a user disables a reminder, THE App SHALL cancel all scheduled notifications for that hobby
5. THE App SHALL request notification permissions on first reminder setup

### Requirement 11: Photo/Media Log

**User Story:** As a user, I want to attach photos to my sessions, so that I can visually document my progress.

#### Acceptance Criteria

1. WHEN logging or editing a session, THE App SHALL allow the user to attach up to 5 images from camera or gallery
2. WHEN images are attached, THE App SHALL store them locally and display thumbnails on the session detail
3. WHEN a user taps a thumbnail, THE App SHALL display the full-size image
4. WHEN a session is deleted, THE App SHALL also delete associated images from local storage

### Requirement 12: Export Data

**User Story:** As a user, I want to export my hobby data, so that I can back it up or analyze it externally.

#### Acceptance Criteria

1. WHEN a user selects "Export as CSV", THE App SHALL generate a CSV file containing all hobbies, sessions, and goals
2. WHEN a user selects "Export as PDF", THE App SHALL generate a PDF report with summary stats and charts
3. WHEN export is complete, THE App SHALL present the system share sheet to save or send the file
4. THE App SHALL include date range filtering for exports

### Requirement 13: Dark Mode

**User Story:** As a user, I want to switch between light and dark themes, so that I can use the app comfortably in any lighting.

#### Acceptance Criteria

1. WHEN a user toggles dark mode in settings, THE App SHALL immediately switch the theme
2. THE App SHALL persist the theme preference and restore it on next launch
3. THE App SHALL support "System" option that follows the device theme setting
4. All screens, charts, and components SHALL render correctly in both themes

### Requirement 14: Cloud Sync (Firebase)

**User Story:** As a user, I want to back up my data to the cloud, so that I can access it across devices.

#### Acceptance Criteria

1. WHEN a user signs in with Google or email, THE App SHALL authenticate via Firebase Auth
2. WHEN sync is enabled, THE App SHALL upload all local data to Cloud Firestore
3. WHEN the app launches with sync enabled, THE App SHALL merge remote data with local data, preferring the most recently updated record
4. WHEN a user signs out, THE App SHALL retain local data but stop syncing
5. THE App SHALL handle offline gracefully and sync when connectivity is restored

### Requirement 15: Onboarding

**User Story:** As a new user, I want a brief walkthrough, so that I understand the app's features.

#### Acceptance Criteria

1. WHEN the app is launched for the first time, THE App SHALL display a 3-screen onboarding flow
2. WHEN the user completes or skips onboarding, THE App SHALL navigate to the dashboard and not show onboarding again
3. THE App SHALL persist the onboarding-completed flag in shared preferences

### Requirement 16: Settings Screen

**User Story:** As a user, I want a settings screen to manage preferences.

#### Acceptance Criteria

1. THE App SHALL provide a Settings screen accessible from the bottom navigation or profile
2. Settings SHALL include: theme toggle, notification preferences, cloud sync toggle, export options, about/version info
3. WHEN a user changes a setting, THE App SHALL persist it immediately

### Requirement 17: In-App Update Checker

**User Story:** As a user, I want to be notified when a new version of the app is available on GitHub, so that I can update to the latest release.

#### Acceptance Criteria

1. WHEN the app launches (or the user taps "Check for updates" in settings), THE App SHALL query the GitHub Releases API for the latest release of `ashwani983/HobbyTracker`
2. WHEN a newer version tag exists compared to the running app version, THE App SHALL display a banner or dialog informing the user of the available update with the release title and release notes summary
3. WHEN the user taps "Update", THE App SHALL open the browser to the GitHub release page where the APK can be downloaded
4. WHEN the user taps "Later", THE App SHALL dismiss the prompt and not show it again for 24 hours
5. THE App SHALL compare versions using semantic versioning (major.minor.patch)
6. THE App SHALL handle network errors gracefully — if the check fails, it SHALL silently skip without disrupting the user experience
7. THE App SHALL show the current app version and a "Check for updates" button on the Settings screen


### Requirement 18: Back Button Navigation

**User Story:** As a user, I want to navigate back to the previous screen using the on-screen back button, so that I can move through the app without getting lost.

#### Acceptance Criteria

1. WHEN a user is on a sub-page accessed from Settings (Cloud Sync, Export, Badges, Terms), THE App SHALL display a back arrow in the AppBar that navigates back to the Settings screen
2. WHEN a user is on the Settings screen, THE App SHALL display a back arrow in the AppBar that navigates back to the Dashboard
3. THE App SHALL show the back arrow as the leading widget in the AppBar on all sub-pages that are not bottom navigation tabs
