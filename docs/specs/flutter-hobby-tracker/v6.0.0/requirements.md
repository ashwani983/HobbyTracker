# Requirements Document — v6.0.0 (Intelligence)

## Introduction

Version 6.0.0 adds predictive and emotional intelligence to the app. The app moves from passively recording activity to actively anticipating user needs — smart scheduling, mood tracking, focus scoring, predictive goals, adaptive reminders, and advanced data visualization. All v1–v5 features remain intact.

## Glossary

- **Focus Score**: A 0–100 metric measuring session quality based on duration, pauses, timing, and Pomodoro completion
- **Mood Lift**: The average difference between post-session and pre-session mood ratings for a hobby
- **Smart Schedule**: An AI-generated weekly timetable suggesting optimal practice times per hobby
- **Adaptive Reminder**: A notification whose timing adjusts based on the user's historical behavior patterns
- **Sankey Diagram**: A flow diagram showing how time distributes from days to hobbies to goals
- **Radar Chart**: A multi-axis chart showing several metrics for a single hobby simultaneously

## Requirements

### Requirement 39: Smart Scheduling

**User Story:** As a user, I want the app to suggest the best times for each hobby, so that I can optimize my daily schedule.

#### Acceptance Criteria

1. WHEN a user has 30+ sessions, THE App SHALL analyze time-of-day and day-of-week patterns per hobby
2. THE App SHALL generate a suggested weekly schedule based on historically high-engagement times
3. THE App SHALL detect schedule conflicts with device calendar events and adjust suggestions
4. WHEN a user accepts a suggested time slot, THE App SHALL create a reminder for that slot
5. THE App SHALL re-evaluate suggestions weekly based on new session data
6. ALL scheduling logic SHALL run on-device

---

### Requirement 40: Mood & Energy Tracking

**User Story:** As a user, I want to log my mood before and after sessions, so that I can understand how hobbies affect my well-being.

#### Acceptance Criteria

1. WHEN a user starts a session, THE App SHALL optionally prompt for a pre-session mood (5-point emoji scale: 😞 😕 😐 🙂 😄)
2. WHEN a session ends, THE App SHALL optionally prompt for a post-session mood
3. THE App SHALL display mood trends over time on a dedicated Wellness screen
4. THE App SHALL calculate a per-hobby "mood lift" score (average post-mood minus pre-mood)
5. THE App SHALL display a weekly mood summary on the dashboard
6. THE AI Coach SHALL incorporate mood data into suggestions (e.g., "Guitar tends to improve your mood on Mondays")
7. Mood prompts SHALL be dismissible and the feature SHALL be toggleable in settings

---

### Requirement 41: Focus Score

**User Story:** As a user, I want to know how focused my sessions are, so that I can improve the quality of my practice.

#### Acceptance Criteria

1. THE App SHALL calculate a Focus Score (0–100) per session based on:
   - Session duration vs. typical duration for that hobby (closer to average = higher)
   - Number of pauses during the session (fewer = higher)
   - Time of day compared to user's peak productivity times (closer to peak = higher)
   - Pomodoro completion rate if applicable (higher = higher)
2. THE App SHALL display the Focus Score on the session detail and hobby detail screens
3. THE App SHALL show a Focus Score trend chart (daily averages over selected period)
4. THE AI Coach SHALL suggest focus improvement tips based on low-scoring patterns
5. THE App SHALL award a "Deep Focus" badge for 10 consecutive sessions with Focus Score > 80

---

### Requirement 42: Predictive Goals

**User Story:** As a user, I want the app to predict whether I'll meet my goals and suggest adjustments, so that I can stay on track.

#### Acceptance Criteria

1. WHEN a goal is active, THE App SHALL calculate a completion probability (0–100%) based on current pace vs. required pace
2. WHEN probability drops below 50%, THE App SHALL notify the user with a suggested catch-up plan
3. THE App SHALL display a projected trajectory line on the goal progress chart
4. THE AI Coach SHALL generate adaptive recommendations (e.g., "Add 15 min on Thu and Fri to meet your guitar goal")
5. WHEN a user consistently exceeds goals, THE App SHALL suggest increasing the target

---

### Requirement 43: Smart Reminders

**User Story:** As a user, I want reminders that adapt to my behavior, so that they arrive at the right time.

#### Acceptance Criteria

1. THE App SHALL analyze session history to determine the user's most likely practice times per hobby
2. WHEN a user hasn't started a session by their usual time, THE App SHALL send an adaptive reminder
3. THE App SHALL suppress reminders on days when the user has already logged sufficient time
4. THE App SHALL learn from dismissed reminders (reduce frequency for repeatedly dismissed times)
5. THE user SHALL be able to toggle between manual reminders and smart reminders per hobby

---

### Requirement 44: Data Visualization 2.0

**User Story:** As a user, I want rich interactive visualizations, so that I can explore my data in depth.

#### Acceptance Criteria

1. THE App SHALL support interactive charts with pinch-to-zoom and pan on mobile, hover tooltips on desktop
2. THE App SHALL provide a Sankey diagram showing time flow from days → hobbies → goals
3. THE App SHALL provide a radar chart showing multi-dimensional hobby metrics (time, consistency, focus, mood lift, streak)
4. THE App SHALL provide comparative views allowing side-by-side analysis of two hobbies
5. THE App SHALL support chart export as PNG image (share or save)
6. ALL charts SHALL be fully accessible (screen reader descriptions, keyboard navigation)
7. Web/desktop SHALL display charts in larger format with more data density
