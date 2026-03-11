# Requirements Document — v4.0.0 (Connected)

## Introduction

Version 4.0.0 focuses on community, advanced routines, wearable/health integration, calendar sync, enhanced timer modes, and accessibility. It transforms the app from a solo tool into a connected experience while ensuring inclusivity. All v1–v3 features remain intact.

## Glossary

- **Routine**: An ordered sequence of hobbies to be performed in a single session, each with a target duration
- **Challenge**: A time-bound competitive or cooperative goal shared between multiple users
- **Accountability Partner**: Another user linked to your account who can see your streaks and goal progress
- **Pomodoro**: A timer technique alternating focused work intervals with short breaks
- **Heatmap**: A calendar-style grid where each day is colored by intensity of activity
- **Deep Link**: A URL that opens a specific screen or context within the app
- **Accessibility (a11y)**: Design practices ensuring the app is usable by people with disabilities
- **Wearable**: A smartwatch or fitness band (Wear OS / watchOS) that communicates with the app

## Requirements

### Requirement 21: Routines & Habit Chaining

**User Story:** As a user, I want to group hobbies into routines, so that I can follow a structured practice schedule without manually starting each session.

#### Acceptance Criteria

1. WHEN a user creates a routine, THE App SHALL allow selecting 2–10 hobbies in a specific order, each with a target duration in minutes
2. WHEN a user starts a routine, THE App SHALL sequentially start the timer for each hobby, auto-advancing to the next hobby when the target duration elapses
3. WHEN transitioning between hobbies in a routine, THE App SHALL play a notification sound and display the next hobby name for 5 seconds before starting
4. WHEN a routine completes, THE App SHALL create individual session records for each hobby with their actual durations
5. WHEN a user pauses a routine mid-sequence, THE Timer SHALL pause on the current hobby and preserve position and elapsed time for all hobbies
6. WHEN a user aborts a routine, THE App SHALL offer to save sessions for hobbies already completed in the sequence
7. THE App SHALL allow scheduling routines for specific days and times, creating recurring reminders
8. THE App SHALL persist routine definitions and schedules to the local database and sync to cloud when enabled

---

### Requirement 22: Advanced Timer Modes

**User Story:** As a user, I want different timer techniques (Pomodoro, countdown, intervals), so that I can match the timer to my practice style.

#### Acceptance Criteria

1. THE App SHALL offer three timer modes: **Stopwatch** (existing), **Countdown**, and **Pomodoro**
2. WHEN a user selects Countdown mode, THE App SHALL allow setting a target duration, count down to zero, and play an alarm when complete
3. WHEN a user selects Pomodoro mode, THE App SHALL alternate between a configurable focus interval (default 25 min) and break interval (default 5 min)
4. WHEN a Pomodoro focus interval ends, THE App SHALL log it as session time and prompt the user to start the break
5. WHEN a Pomodoro cycle completes 4 focus intervals, THE App SHALL suggest a long break (default 15 min)
6. THE App SHALL display the current mode, interval count, and elapsed/remaining time on the timer screen
7. WHEN a user customizes Pomodoro intervals, THE App SHALL persist the preferences and use them as defaults
8. ALL timer modes SHALL continue tracking in the background when the user navigates away

---

### Requirement 23: Calendar Integration

**User Story:** As a user, I want to see my hobby sessions on a calendar and sync them with my external calendar, so that I can manage my time holistically.

#### Acceptance Criteria

1. THE App SHALL display a monthly calendar view where each day shows colored dots for hobbies practiced that day
2. WHEN a user taps a day on the calendar, THE App SHALL show all sessions logged on that date
3. WHEN the user enables "Calendar Sync" in settings, THE App SHALL create events in the device's default calendar for each logged session
4. WHEN a session is deleted, THE App SHALL also remove the corresponding calendar event (if sync is enabled)
5. THE App SHALL display a heatmap view showing activity intensity over the past 12 months
6. THE heatmap SHALL use a gradient from light to dark based on total minutes logged per day
7. WHEN a user taps a cell in the heatmap, THE App SHALL display a tooltip with the date and total duration

---

### Requirement 24: Community Challenges

**User Story:** As a user, I want to participate in challenges with other users, so that I have social motivation to stay consistent.

#### Acceptance Criteria

1. WHEN a user creates a challenge, THE App SHALL require a name, target hobby category, target total duration, start date, end date, and participant limit (2–50)
2. WHEN a challenge is created, THE App SHALL generate a unique invite code and deep link that can be shared
3. WHEN a user enters an invite code or taps a deep link, THE App SHALL add them to the challenge if it has not started or is still accepting participants
4. WHEN a challenge is active, THE App SHALL display a leaderboard showing each participant's accumulated duration, ranked in descending order
5. WHEN the challenge end date passes, THE App SHALL mark the top 3 participants as winners and award a special badge
6. WHEN a challenge is active, THE App SHALL update leaderboard data via Cloud Firestore in real-time
7. THE App SHALL require cloud sync to be enabled for challenge participation
8. WHEN a user leaves a challenge, THE App SHALL remove them from the leaderboard but retain their session data locally

---

### Requirement 25: Accountability Partners

**User Story:** As a user, I want to link with a friend as an accountability partner, so that we can see each other's progress and stay motivated.

#### Acceptance Criteria

1. WHEN a user sends a partner request, THE App SHALL generate an invite code valid for 48 hours
2. WHEN the other user accepts, THE App SHALL establish a bidirectional link visible in both users' profiles
3. WHEN linked, EACH partner SHALL see the other's current streak, weekly active time, and goal completion percentage on a dedicated "Partner" card on the dashboard
4. THE App SHALL NOT share session notes, ratings, or media with the partner — only aggregated stats
5. WHEN a partner breaks a streak of 7+ days, THE App SHALL send a notification to the other partner
6. WHEN either user removes the partnership, THE App SHALL sever the link and remove shared data from both accounts immediately
7. THE App SHALL limit each user to a maximum of 5 active accountability partners

---

### Requirement 26: Wearable Integration

**User Story:** As a user, I want to start timers and see stats on my smartwatch, so that I can track hobbies without reaching for my phone.

#### Acceptance Criteria

1. THE App SHALL provide a Wear OS companion app that displays the list of active hobbies
2. WHEN a user starts a timer on the watch, THE watch app SHALL sync the running timer state with the phone app
3. WHEN a timer is stopped on the watch, THE phone app SHALL receive the elapsed duration and prompt session saving on next open
4. THE watch app SHALL display today's total time and current streak as a complication / tile
5. THE App SHALL sync hobby list changes to the watch within 30 seconds of modification
6. IF the phone is unreachable, THE watch app SHALL store timer data locally and sync when reconnected
7. THE App SHALL provide equivalent watchOS (Apple Watch) support using the same feature set

---

### Requirement 27: Accessibility (a11y)

**User Story:** As a user with disabilities, I want the app to be fully accessible, so that I can use all features with assistive technologies.

#### Acceptance Criteria

1. ALL interactive elements SHALL have semantic labels compatible with TalkBack (Android) and VoiceOver (iOS)
2. THE App SHALL support dynamic font scaling up to 200% without layout overflow or text truncation
3. ALL color-coded information (charts, heatmap, badges) SHALL have a secondary non-color indicator (pattern, icon, or label)
4. THE App SHALL meet WCAG 2.1 AA contrast ratios for all text and interactive elements in both light and dark themes
5. THE App SHALL support full keyboard/switch navigation on every screen
6. THE timer screen SHALL announce elapsed time via screen reader at configurable intervals (every 30s, 1min, or 5min)
7. THE App SHALL include a high-contrast mode toggle in settings that increases contrast beyond the default themes

---

### Requirement 28: Advanced Analytics & Insights

**User Story:** As a user, I want deeper insights into my hobby patterns, so that I can optimize my schedule and identify trends.

#### Acceptance Criteria

1. THE App SHALL display a correlation matrix showing which hobbies are frequently practiced on the same day
2. THE App SHALL calculate and display the user's most productive day of the week and most productive time of day based on session history
3. THE App SHALL show a consistency score (0–100) for each hobby based on regularity of sessions over the past 30 days
4. THE App SHALL display rolling averages (7-day, 30-day) for session duration on the hobby detail screen
5. THE App SHALL generate a monthly summary report (viewable in-app) with total time, most active hobby, streak stats, goals completed, and badges earned
6. WHEN the user opens the analytics screen, THE App SHALL calculate all metrics from local data without requiring network access
7. THE App SHALL allow the user to pin up to 3 metrics to the dashboard for quick viewing

---

### Requirement 29: Audio Notes

**User Story:** As a user, I want to record voice memos for my sessions, so that I can capture thoughts without typing.

#### Acceptance Criteria

1. WHEN logging or editing a session, THE App SHALL allow recording one audio note of up to 2 minutes
2. WHEN recording, THE App SHALL display a waveform visualization and elapsed recording time
3. WHEN playback is requested, THE App SHALL play the audio with play/pause and seek controls
4. WHEN a session is deleted, THE App SHALL also delete the associated audio file from local storage
5. Audio files SHALL be stored in the app's private directory and synced to cloud storage (Firebase Storage) when cloud sync is enabled
6. THE App SHALL compress audio to AAC format at 64kbps to minimize storage

---

### Requirement 30: Deep Linking & URL Scheme

**User Story:** As a user, I want to open specific screens via links, so that notifications, widgets, and shared links work seamlessly.

#### Acceptance Criteria

1. THE App SHALL register a custom URL scheme: `hobbytracker://`
2. THE App SHALL support the following deep link routes:
   - `hobbytracker://dashboard`
   - `hobbytracker://hobby/{id}`
   - `hobbytracker://timer/{hobbyId}`
   - `hobbytracker://challenge/{inviteCode}`
3. WHEN a deep link is received while the app is closed, THE App SHALL cold-start and navigate to the target screen
4. WHEN a deep link is received while the app is open, THE App SHALL navigate to the target screen without restarting
5. THE App SHALL validate deep link parameters and navigate to the dashboard if the route is invalid
6. THE App SHALL support Firebase Dynamic Links for challenge invitations that work across app install states
