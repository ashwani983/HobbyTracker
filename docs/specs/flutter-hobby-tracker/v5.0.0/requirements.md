# Requirements Document — v5.0.0 (Platform & Monetization)

## Introduction

Version 5.0.0 expands to web/desktop, introduces a premium subscription model, adds advanced AI coaching, custom theming, and plugin/integration architecture. This version prepares the app for sustainable growth. All v1–v4 features remain intact.

## Glossary

- **Coach**: An AI-powered conversational agent that provides personalized advice based on user behavior
- **Theme Pack**: A downloadable set of colors, icons, and fonts that customize the app's appearance
- **Plugin**: A modular integration that connects the app to an external service (Spotify, Strava, etc.)
- **Freemium**: A business model offering basic features for free and advanced features via subscription
- **Sync Conflict**: A state where local and remote data differ and must be reconciled

## Requirements

### Requirement 31: Web & Desktop Support

**User Story:** As a user, I want to access my hobby data from a browser or desktop app, so that I'm not limited to my phone.

#### Acceptance Criteria

1. THE App SHALL compile and run as a Progressive Web App (PWA) accessible via any modern browser
2. THE App SHALL compile and run as native desktop apps for macOS, Windows, and Linux
3. THE web/desktop version SHALL support all features except: wearable integration (Req 26), home screen widgets (Req 19), and audio notes recording (playback only)
4. THE web/desktop version SHALL use responsive layouts:
   - < 600px: single-column mobile layout
   - 600–1200px: two-column tablet layout
   - > 1200px: three-column desktop layout with persistent side navigation
5. THE App SHALL replace bottom navigation with a collapsible side rail on screens wider than 800px
6. THE App SHALL use the same Firebase backend for authentication and sync across all platforms
7. WHEN a user modifies data on any platform, THE App SHALL sync changes to all other signed-in platforms within 10 seconds (when online)

---

### Requirement 32: AI Coaching

**User Story:** As a user, I want a personal AI coach that gives me actionable advice, so that I can improve my consistency and reach my goals faster.

#### Acceptance Criteria

1. THE App SHALL provide a "Coach" tab accessible from navigation, displaying a chat-style interface
2. WHEN the user opens the Coach screen, THE App SHALL generate a daily briefing summarizing yesterday's activity, today's goals, and a motivational tip
3. WHEN the user asks a question, THE Coach SHALL respond with data-backed suggestions derived from the user's session history
4. THE Coach SHALL proactively generate alerts when:
   - A goal is at risk of not being met (< 50% complete with < 30% time remaining)
   - A streak is about to break (no session logged by 8 PM local time)
   - A hobby has not been practiced in 14+ days
5. ALL inference SHALL run on-device using a lightweight model (TensorFlow Lite or equivalent)
6. THE Coach SHALL NOT send any user data to external servers
7. THE App SHALL allow disabling the Coach feature entirely in settings

---

### Requirement 33: Premium Subscription (Freemium)

**User Story:** As a developer, I want a sustainable monetization model, so that I can continue improving the app.

#### Acceptance Criteria

1. THE App SHALL offer two tiers: Free and Premium ($2.99/month or $24.99/year)
2. Free tier SHALL include:
   - Up to 5 active hobbies
   - Session logging, timer (stopwatch mode only), basic dashboard, basic charts
   - Local storage only
   - Standard themes (light/dark)
3. Premium tier SHALL unlock:
   - Unlimited hobbies
   - All timer modes (Pomodoro, countdown)
   - Advanced analytics & insights
   - AI coaching
   - Cloud sync
   - Routines
   - Media attachments
   - Custom themes
   - CSV/PDF export
   - Priority support
4. THE App SHALL manage subscriptions via RevenueCat (wrapping App Store & Google Play billing)
5. THE App SHALL verify subscription status on each app launch and sync it with Firebase
6. WHEN a Premium user's subscription expires, THE App SHALL downgrade to Free tier gracefully:
   - Hobbies beyond 5 SHALL become read-only (not deleted)
   - Cloud data SHALL be retained for 90 days
   - Advanced features SHALL become inaccessible but data SHALL be preserved
7. THE App SHALL offer a 7-day free trial for new users
8. THE App SHALL never lock existing user data behind the paywall — only feature access is gated

---

### Requirement 34: Custom Themes & Appearance

**User Story:** As a user, I want to fully customize the app's look and feel, so that it reflects my personality.

#### Acceptance Criteria

1. THE App SHALL allow Premium users to create custom themes by selecting: primary color, secondary color, background color, font family (from 5 options), and icon style (outline/filled/rounded)
2. THE App SHALL provide 10 pre-designed theme packs (e.g., "Ocean", "Sunset", "Minimal Mono", "Neon")
3. WHEN a user applies a custom theme, THE App SHALL apply it to all screens, charts, and components immediately
4. THE App SHALL persist custom themes locally and sync them to cloud
5. THE App SHALL allow sharing a theme as a code string that other users can import
6. Free-tier users SHALL have access to the default light and dark themes only

---

### Requirement 35: Integration Plugins

**User Story:** As a user, I want to connect the app with other services I use, so that my hobby data enriches my broader digital life.

#### Acceptance Criteria

1. THE App SHALL provide a plugin architecture allowing modular integrations
2. THE App SHALL ship with the following built-in plugins:
   - Spotify: Auto-detect currently playing music during a session and log the track/playlist
   - Google Fit / Apple Health: Sync session durations as "Mindfulness" or custom activity entries
   - Google Calendar / Apple Calendar: Two-way sync of sessions and routine schedules
   - Strava: For sports hobbies, import activity data as sessions
3. EACH plugin SHALL have an enable/disable toggle in settings and request only necessary permissions
4. WHEN a plugin sync fails, THE App SHALL log the error, notify the user, and retry up to 3 times with exponential backoff
5. THE App SHALL expose a documented plugin interface so that community developers can build additional integrations in future versions
6. Plugin data SHALL be stored alongside session data and included in exports

---

### Requirement 36: Offline-First Architecture Improvements

**User Story:** As a user, I want the app to work flawlessly offline and resolve conflicts intelligently when I reconnect.

#### Acceptance Criteria

1. THE App SHALL queue all write operations locally when offline and execute them against Firebase when connectivity is restored
2. WHEN a sync conflict occurs, THE App SHALL use a last-write-wins strategy based on `updatedAt` timestamps with millisecond precision
3. THE App SHALL display a sync status indicator (synced / syncing / offline / error) in the app bar
4. WHEN the user is offline for more than 7 days, THE App SHALL show an advisory notification recommending sync
5. THE App SHALL support selective sync — users can choose which data types to sync (hobbies, sessions, goals, media, themes)
6. THE App SHALL log all sync operations to a local audit trail viewable in settings (last 100 entries)

---

### Requirement 37: Advanced Goal System

**User Story:** As a user, I want more flexible goals, so that I can set targets that match my real-world aspirations.

#### Acceptance Criteria

1. THE App SHALL support the following goal types: weekly, monthly, yearly, cumulative (no end date), and streak-based (e.g., practice 5 days/week)
2. WHEN a user creates a streak-based goal, THE App SHALL track the number of distinct days with sessions per week/month and compare against the target
3. THE App SHALL support milestone goals with multiple checkpoints (e.g., 10h → 50h → 100h) that unlock sequentially
4. WHEN a milestone is reached, THE App SHALL trigger a celebration animation and optional badge unlock
5. THE App SHALL allow attaching goals to routines — completing N routine sessions per week counts toward the goal
6. THE App SHALL display a goal timeline view showing projected completion date based on recent activity trends
7. ALL new goal types SHALL be available to Premium users; Free-tier users retain weekly and monthly goals

---

### Requirement 38: In-App Feedback & Community

**User Story:** As a user, I want to submit feedback and see community feature requests, so that I can influence the app's direction.

#### Acceptance Criteria

1. THE App SHALL provide a "Feedback" option in settings that opens a form for bug reports and feature requests
2. WHEN a user submits feedback, THE App SHALL send it to a Firebase collection with device info, app version, and user ID (if signed in)
3. THE App SHALL display a "Community Board" (read-only) showing top-voted feature requests fetched from a public endpoint
4. THE App SHALL allow Premium users to upvote feature requests (max 5 votes)
5. THE App SHALL include a "Rate this app" prompt after the user has logged 20 sessions, shown at most once
