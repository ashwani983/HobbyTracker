# Privacy Policy

**Hobby Tracker**
Last updated: April 11, 2026

## Overview

Hobby Tracker is a mobile application that helps you track hobbies, log sessions, set goals, and view statistics. Your privacy is important to us. This policy explains what data we collect, how we use it, and your choices.

## Data Collection

### Data Stored Locally

All core app data is stored locally on your device using an SQLite database. This includes:

- Hobbies you create (name, category, color, icon)
- Sessions you log (duration, notes, ratings, photos)
- Goals you set (type, target, dates)
- Badges and streaks
- App preferences (theme, language, reminders)

This data never leaves your device unless you explicitly enable Cloud Sync.

### Cloud Sync (Optional)

If you choose to enable Cloud Sync:

- You sign in using your account credentials
- Your hobbies, sessions, and goals are synced to a cloud database (Firebase Cloud Firestore)
- Data is stored under your authenticated user ID and is only accessible by you
- You can disable sync or delete your cloud data at any time from the app settings

### Photos

If you attach photos to sessions:

- Photos are stored locally on your device
- Photos are not uploaded to any server or cloud service
- Camera and gallery access is only used when you explicitly choose to attach a photo

### Notifications

If you enable reminders:

- Notification schedules are stored locally on your device
- No notification data is sent to any external server

## Data We Do Not Collect

- We do not collect personal information (name, email, phone number) unless you sign in for Cloud Sync
- We do not collect location data
- We do not collect usage analytics or telemetry
- We do not use advertising SDKs or trackers
- We do not sell, share, or transfer your data to third parties

## Third-Party Services

### Firebase (Cloud Sync only)

If you enable Cloud Sync, the app uses Firebase services provided by Google:

- **Firebase Authentication** — to verify your identity
- **Cloud Firestore** — to store your synced data

Firebase's privacy policy: [https://firebase.google.com/support/privacy](https://firebase.google.com/support/privacy)

If you do not enable Cloud Sync, no data is sent to Firebase.

## Data Retention

- Local data remains on your device until you uninstall the app or clear app data
- Cloud data (if sync is enabled) remains until you delete it from settings or delete your account

## Children's Privacy

Hobby Tracker does not knowingly collect data from children under 13. The app does not require an account to use and stores all data locally by default.

## Changes to This Policy

We may update this privacy policy from time to time. Changes will be reflected by updating the "Last updated" date above.

## Contact

If you have questions about this privacy policy, please open an issue at:
[https://github.com/ashwani983/HobbyTracker/issues](https://github.com/ashwani983/HobbyTracker/issues)
