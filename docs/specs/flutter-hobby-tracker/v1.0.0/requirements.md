# Requirements Document

## Introduction

The Flutter Hobby Tracker is a mobile application that enables users to track, manage, and visualize their hobbies. Users can log activity sessions, set goals, and monitor progress over time. This document covers the MVP (Phase 1) features: hobby management, session logging, a built-in timer, a dashboard, goal setting, and progress charts.

## Glossary

- **App**: The Flutter Hobby Tracker mobile application
- **Hobby**: A user-defined activity to be tracked, characterized by a name, icon, color, and category
- **Session**: A recorded period of time spent on a specific hobby, including duration, date, optional notes, and an optional rating
- **Goal**: A target set by the user for a specific hobby, defined by a type (weekly or monthly), a target duration, and a date range
- **Dashboard**: The main summary screen displaying aggregated statistics and recent activity
- **Timer**: A built-in stopwatch component that tracks elapsed time for a live hobby session
- **Category**: A classification label for grouping hobbies (e.g., Sports, Music, Art, Reading)
- **Duration**: A time measurement in minutes representing how long a session lasted
- **Rating**: An integer value from 1 to 5 representing user satisfaction with a session
- **Archive**: A soft-delete state where a hobby is hidden from active views but retained in the database

## Requirements

### Requirement 1: Hobby Management

**User Story:** As a user, I want to add, edit, and delete hobbies, so that I can maintain a personalized list of activities I want to track.

#### Acceptance Criteria

1. WHEN a user submits a new hobby with a valid name, icon, color, and category, THE App SHALL create the hobby and add it to the hobbies list
2. WHEN a user attempts to create a hobby with an empty or whitespace-only name, THE App SHALL reject the creation and display a validation error
3. WHEN a user edits an existing hobby, THE App SHALL update the hobby fields and persist the changes immediately
4. WHEN a user deletes a hobby, THE App SHALL mark the hobby as archived and remove it from the active hobbies list
5. WHEN the hobbies list is displayed, THE App SHALL show only non-archived hobbies sorted by creation date
6. THE App SHALL persist all hobby data to the local SQLite database

### Requirement 2: Session Logging

**User Story:** As a user, I want to log time spent on my hobbies, so that I can keep a record of my activity and review it later.

#### Acceptance Criteria

1. WHEN a user submits a new session with a valid hobby, date, and duration, THE App SHALL create the session and associate it with the specified hobby
2. WHEN a user attempts to log a session with zero or negative duration, THE App SHALL reject the submission and display a validation error
3. WHEN a user views a hobby detail screen, THE App SHALL display all sessions for that hobby sorted by date in descending order
4. WHEN a session is created, THE App SHALL persist the session data to the local SQLite database immediately
5. WHEN a user provides optional notes and a rating for a session, THE App SHALL store the notes as a string and the rating as an integer between 1 and 5
6. IF a user provides a rating outside the range of 1 to 5, THEN THE App SHALL reject the session and display a validation error

### Requirement 3: Built-in Timer

**User Story:** As a user, I want a built-in stopwatch to track time spent on a hobby in real time, so that I do not need to manually calculate session durations.

#### Acceptance Criteria

1. WHEN a user starts the timer for a hobby, THE Timer SHALL begin counting elapsed time from zero and display the running time
2. WHEN a user pauses the timer, THE Timer SHALL stop counting and preserve the elapsed time
3. WHEN a user resumes a paused timer, THE Timer SHALL continue counting from the previously elapsed time
4. WHEN a user stops the timer, THE App SHALL present the total elapsed duration and allow the user to save it as a new session
5. WHEN a user discards a timer session, THE App SHALL reset the timer to zero without creating a session record
6. WHILE the timer is running, THE App SHALL update the displayed elapsed time every second
7. IF the timer is running and the user navigates away from the timer screen, THEN THE App SHALL continue tracking elapsed time in the background

### Requirement 4: Dashboard

**User Story:** As a user, I want a summary dashboard, so that I can quickly see my overall hobby activity and recent sessions at a glance.

#### Acceptance Criteria

1. WHEN the user opens the dashboard, THE App SHALL display the total number of active hobbies
2. WHEN the user opens the dashboard, THE App SHALL display the total time spent across all hobbies for the current week
3. WHEN the user opens the dashboard, THE App SHALL display a list of the five most recent sessions with hobby name, date, and duration
4. WHEN a new session is logged, THE Dashboard SHALL reflect the updated statistics without requiring a manual refresh
5. WHEN the user has no hobbies or sessions, THE Dashboard SHALL display an empty state message guiding the user to add a hobby

### Requirement 5: Goal Setting

**User Story:** As a user, I want to set weekly or monthly time goals for my hobbies, so that I can stay motivated and measure my commitment.

#### Acceptance Criteria

1. WHEN a user creates a goal with a valid hobby, type (weekly or monthly), target duration, start date, and end date, THE App SHALL create the goal and associate it with the specified hobby
2. WHEN a user attempts to create a goal with a target duration of zero or less, THE App SHALL reject the creation and display a validation error
3. WHEN a user attempts to create a goal where the end date is before the start date, THE App SHALL reject the creation and display a validation error
4. WHEN a user views the goals screen, THE App SHALL display all active goals with current progress as a percentage of the target duration
5. WHEN the accumulated session duration for a goal's hobby within the goal's date range meets or exceeds the target duration, THE App SHALL mark the goal as completed
6. THE App SHALL persist all goal data to the local SQLite database
7. WHEN a user deactivates a goal, THE App SHALL set the goal's active status to false and remove it from the active goals list

### Requirement 6: Progress Charts

**User Story:** As a user, I want to see visual charts of my hobby activity, so that I can understand trends and patterns in my time allocation.

#### Acceptance Criteria

1. WHEN the user opens the stats screen, THE App SHALL display a bar chart showing total duration per hobby for the selected time period
2. WHEN the user opens the stats screen, THE App SHALL display a pie chart showing the proportion of time spent on each hobby
3. WHEN the user opens the stats screen, THE App SHALL display a line chart showing daily total session duration over the selected time period
4. WHEN the user selects a different time period (week, month, or year), THE App SHALL recalculate and redraw all charts for the selected range
5. WHEN a hobby has no sessions in the selected time period, THE App SHALL exclude that hobby from the charts
6. IF no sessions exist for any hobby in the selected time period, THEN THE App SHALL display an empty state message instead of empty charts

### Requirement 7: Local Data Persistence

**User Story:** As a user, I want my data to be stored locally on my device, so that I can access my hobbies and sessions without an internet connection.

#### Acceptance Criteria

1. THE App SHALL store all hobby, session, and goal data in a local SQLite database using the Drift ORM
2. WHEN the app launches, THE App SHALL initialize the database and load existing data
3. WHEN data is created or modified, THE App SHALL persist changes to the database before confirming the operation to the user
4. IF the database operation fails, THEN THE App SHALL display an error message and preserve the previous state

### Requirement 8: Navigation and Screen Structure

**User Story:** As a user, I want intuitive navigation between screens, so that I can move through the app efficiently.

#### Acceptance Criteria

1. THE App SHALL provide a bottom navigation bar with tabs for Dashboard, Hobbies, Timer, Goals, and Stats
2. WHEN the user taps a bottom navigation tab, THE App SHALL navigate to the corresponding screen
3. WHEN the user taps a hobby in the hobbies list, THE App SHALL navigate to the hobby detail screen showing sessions and statistics for that hobby
4. THE App SHALL use go_router for declarative routing with named routes
