# Implementation Plan — v5.0.0 (Platform & Monetization)

## Overview

Builds on v1–v4 (Clean Architecture + BLoC + Drift). Adds web/desktop support, AI coaching, freemium model, custom themes, integration plugins, offline-first improvements, advanced goals, and community feedback. Estimated: 12 weeks (6 sprints).

## Sprint 1: Responsive Layout & Web/Desktop

- [ ] 1. Web & Desktop Support (Req 31)
  - [ ] 1.1 Add `responsive_framework` and `window_manager` dependencies
  - [ ] 1.2 Enable web, macOS, Windows, Linux targets in Flutter project
  - [ ] 1.3 Implement responsive `AppShell` — `NavigationBar` (< 800px) vs `NavigationRail` (≥ 800px)
    - _Requirements: 31.5_
  - [ ] 1.4 Implement responsive layouts: single-column (< 600px), two-column (600–1200px), three-column (> 1200px)
    - _Requirements: 31.4_
  - [ ] 1.5 Configure Firebase for web platform (auth, firestore)
    - _Requirements: 31.6_
  - [ ] 1.6 Disable unsupported features on web/desktop (wearable, widgets, audio recording)
    - _Requirements: 31.3_
  - [ ] 1.7 Configure PWA manifest and service worker
    - _Requirements: 31.1_
  - [ ] 1.8 Build and test on macOS, Windows, Linux, Chrome
    - _Requirements: 31.2_
  - [ ] 1.9 Verify cross-platform sync within 10 seconds
    - _Requirements: 31.7_

- [ ] 2. Checkpoint — Web & Desktop

## Sprint 2: Premium Subscription & Custom Themes

- [ ] 3. Premium Subscription (Req 33)
  - [ ] 3.1 Add `purchases_flutter` (RevenueCat) dependency
  - [ ] 3.2 Add `UserSubscriptions` Drift table, run `build_runner`
  - [ ] 3.3 Create `UserSubscription` entity and `SubscriptionRepository`
  - [ ] 3.4 Implement `CheckSubscription`, `PurchaseSubscription`, `RestorePurchase` use cases
    - _Requirements: 33.4, 33.5_
  - [ ] 3.5 Create `SubscriptionCubit` — check tier on launch, gate features
    - _Requirements: 33.5_
  - [ ] 3.6 Implement `FeatureGate` utility for free vs premium access checks
    - _Requirements: 33.2, 33.3_
  - [ ] 3.7 Build `SubscriptionScreen` with tier comparison, purchase, restore, trial
    - _Requirements: 33.1, 33.7_
  - [ ] 3.8 Implement graceful downgrade on expiry (read-only hobbies, 90-day cloud retention)
    - _Requirements: 33.6, 33.8_
  - [ ] 3.9 Add `/subscription` route

- [ ] 4. Checkpoint — Subscription

- [ ] 5. Custom Themes & Appearance (Req 34)
  - [ ] 5.1 Add `google_fonts` and `flex_color_picker` dependencies
  - [ ] 5.2 Add `CustomThemes` Drift table, run `build_runner`
  - [ ] 5.3 Create `CustomTheme`, `ThemePack` entities and `CustomThemeRepository`
  - [ ] 5.4 Implement `CreateCustomTheme`, `ApplyTheme`, `ShareTheme`, `ImportTheme` use cases
    - _Requirements: 34.1, 34.3, 34.5_
  - [ ] 5.5 Extend `ThemeCubit` to `CustomThemeCubit` supporting custom color schemes and fonts
  - [ ] 5.6 Create 10 pre-designed theme packs
    - _Requirements: 34.2_
  - [ ] 5.7 Build `ThemeEditorScreen` with color pickers, font selector, icon style, preview
    - _Requirements: 34.1_
  - [ ] 5.8 Sync custom themes to cloud
    - _Requirements: 34.4_
  - [ ] 5.9 Gate custom themes behind premium; free users get light/dark only
    - _Requirements: 34.6_
  - [ ] 5.10 Add `/themes` route

- [ ] 6. Checkpoint — Themes

## Sprint 3: AI Coaching

- [ ] 7. AI Coaching (Req 32)
  - [ ] 7.1 Add `tflite_flutter` dependency
  - [ ] 7.2 Create `CoachMessage` entity and `CoachRepository`
  - [ ] 7.3 Implement on-device inference pipeline (TFLite model loading, input preparation, output parsing)
    - _Requirements: 32.5_
  - [ ] 7.4 Implement `GenerateBriefing` use case — summarize yesterday's activity, today's goals, motivational tip
    - _Requirements: 32.2_
  - [ ] 7.5 Implement `AskCoach` use case — data-backed suggestions from session history
    - _Requirements: 32.3_
  - [ ] 7.6 Implement `GetCoachAlerts` use case — at-risk goals, streak warnings, inactive hobbies
    - _Requirements: 32.4_
  - [ ] 7.7 Create `CoachBloc` with chat message state and proactive alert state
  - [ ] 7.8 Build `CoachScreen` with chat-style interface
    - _Requirements: 32.1_
  - [ ] 7.9 Add Coach disable toggle in settings
    - _Requirements: 32.7_
  - [ ] 7.10 Ensure no user data leaves the device
    - _Requirements: 32.6_
  - [ ] 7.11 Add `/coach` route and navigation entry

- [ ] 8. Checkpoint — AI Coaching

## Sprint 4: Integration Plugins

- [ ] 9. Integration Plugins (Req 35)
  - [ ] 9.1 Add `spotify_sdk`, `health`, `strava_client` dependencies
  - [ ] 9.2 Add `PluginConfigs` Drift table, run `build_runner`
  - [ ] 9.3 Define `HobbyTrackerPlugin` abstract interface
    - _Requirements: 35.1, 35.5_
  - [ ] 9.4 Implement Spotify plugin — detect playing track during session, log to session data
    - _Requirements: 35.2_
  - [ ] 9.5 Implement Google Fit / Apple Health plugin — sync session durations as activities
    - _Requirements: 35.2_
  - [ ] 9.6 Implement Google Calendar / Apple Calendar plugin — two-way sync
    - _Requirements: 35.2_
  - [ ] 9.7 Implement Strava plugin — import sport activities as sessions
    - _Requirements: 35.2_
  - [ ] 9.8 Create `PluginBloc` with enable/disable and sync status per plugin
  - [ ] 9.9 Build `PluginSettingsScreen` with toggle and permission request per plugin
    - _Requirements: 35.3_
  - [ ] 9.10 Implement retry with exponential backoff on plugin sync failure
    - _Requirements: 35.4_
  - [ ] 9.11 Include plugin data in exports
    - _Requirements: 35.6_
  - [ ] 9.12 Add `/plugins` route

- [ ] 10. Checkpoint — Plugins

## Sprint 5: Offline-First & Advanced Goals

- [ ] 11. Offline-First Architecture Improvements (Req 36)
  - [ ] 11.1 Add `connectivity_plus` dependency
  - [ ] 11.2 Add `SyncOperations` Drift table, run `build_runner`
  - [ ] 11.3 Implement offline write queue — queue local writes, process on connectivity restore
    - _Requirements: 36.1_
  - [ ] 11.4 Implement last-write-wins conflict resolution using `updatedAt` timestamps
    - _Requirements: 36.2_
  - [ ] 11.5 Create `SyncStatusCubit` — emit synced/syncing/offline/error states
  - [ ] 11.6 Add sync status indicator (colored dot) to app bar
    - _Requirements: 36.3_
  - [ ] 11.7 Show advisory notification after 7 days offline
    - _Requirements: 36.4_
  - [ ] 11.8 Implement selective sync toggles per data type in settings
    - _Requirements: 36.5_
  - [ ] 11.9 Build `SyncAuditScreen` showing last 100 sync operations
    - _Requirements: 36.6_
  - [ ] 11.10 Add `/sync/audit` route

- [ ] 12. Checkpoint — Offline-First

- [ ] 13. Advanced Goal System (Req 37)
  - [ ] 13.1 Add `MilestoneGoals` Drift table, run `build_runner`
  - [ ] 13.2 Extend goal entity with new types: yearly, cumulative, streak-based
    - _Requirements: 37.1_
  - [ ] 13.3 Implement streak-based goal tracking (distinct days per week/month)
    - _Requirements: 37.2_
  - [ ] 13.4 Implement milestone goals with sequential checkpoints
    - _Requirements: 37.3_
  - [ ] 13.5 Add celebration animation and badge unlock on milestone reach
    - _Requirements: 37.4_
  - [ ] 13.6 Allow attaching goals to routines
    - _Requirements: 37.5_
  - [ ] 13.7 Build goal timeline view with projected completion date
    - _Requirements: 37.6_
  - [ ] 13.8 Gate new goal types behind premium; free users keep weekly/monthly
    - _Requirements: 37.7_
  - [ ] 13.9 Add `/goals/:id/timeline` route

- [ ] 14. Checkpoint — Advanced Goals

## Sprint 6: Feedback, Community & Final

- [ ] 15. In-App Feedback & Community (Req 38)
  - [ ] 15.1 Add `in_app_review` dependency
  - [ ] 15.2 Add `FeedbackEntries` Drift table, run `build_runner`
  - [ ] 15.3 Create `FeedbackEntry` entity and `FeedbackRepository`
  - [ ] 15.4 Implement `SubmitFeedback` use case — send to Firebase collection with device info
    - _Requirements: 38.1, 38.2_
  - [ ] 15.5 Implement `GetCommunityBoard` use case — fetch top-voted requests from public endpoint
    - _Requirements: 38.3_
  - [ ] 15.6 Implement `UpvoteRequest` use case — premium users, max 5 votes
    - _Requirements: 38.4_
  - [ ] 15.7 Create `FeedbackBloc`
  - [ ] 15.8 Build `FeedbackScreen` with bug report / feature request form
    - _Requirements: 38.1_
  - [ ] 15.9 Build `CommunityBoardScreen` with read-only list and upvote buttons
    - _Requirements: 38.3, 38.4_
  - [ ] 15.10 Add "Rate this app" prompt after 20 sessions (shown once)
    - _Requirements: 38.5_
  - [ ] 15.11 Add `/feedback` and `/community` routes

- [ ] 16. Checkpoint — Feedback & Community

- [ ] 17. Final checkpoint — v5.0.0
  - [ ] 17.1 Run full test suite across all platforms, fix regressions
  - [ ] 17.2 Update README and CHANGELOG for v5.0.0
  - [ ] 17.3 Build release APK, web, macOS, Windows, Linux
  - [ ] 17.4 Create GitHub release with tag `v5.0.0`
