# Implementation Plan — v6.0.0 (Intelligence)

## Overview

Builds on v1–v5 (Clean Architecture + BLoC + Drift). Adds smart scheduling, mood tracking, focus scoring, predictive goals, smart reminders, and advanced data visualization. All intelligence runs on-device. Estimated: 12 weeks (6 sprints).

## Sprint 1: Mood & Energy Tracking

- [ ] 1. Mood & Energy Tracking (Req 40)
  - [ ] 1.1 Add `MoodEntryTable` to Drift, bump schema to v8, run `build_runner`
  - [ ] 1.2 Create `MoodEntry` entity and `MoodRepository` with CRUD + aggregation queries
    - _Requirements: 40.1, 40.2_
  - [ ] 1.3 Create `MoodBloc` with SavePreMood, SavePostMood, LoadMoodTrends events
  - [ ] 1.4 Add optional pre-mood prompt at timer start (5-point emoji scale)
    - _Requirements: 40.1_
  - [ ] 1.5 Add optional post-mood prompt in session save dialog
    - _Requirements: 40.2_
  - [ ] 1.6 Build `WellnessScreen` with mood trend chart and per-hobby mood lift scores
    - _Requirements: 40.3, 40.4_
  - [ ] 1.7 Add weekly mood summary card to dashboard
    - _Requirements: 40.5_
  - [ ] 1.8 Add mood toggle in settings (enable/disable prompts)
    - _Requirements: 40.7_
  - [ ] 1.9 Add `/wellness` route and link from More screen

- [ ] 2. Checkpoint — Mood Tracking

## Sprint 2: Focus Score

- [ ] 3. Focus Score (Req 41)
  - [ ] 3.1 Add `FocusScoreTable` to Drift, run `build_runner`
  - [ ] 3.2 Create `FocusScore` entity and `FocusScoreRepository`
  - [ ] 3.3 Implement `FocusScoreCalculator` service with weighted algorithm
    - _Requirements: 41.1_
  - [ ] 3.4 Create `FocusCubit` — auto-calculate score on session save
  - [ ] 3.5 Display Focus Score on session detail and hobby detail screens
    - _Requirements: 41.2_
  - [ ] 3.6 Build Focus Score trend chart (daily averages, period selector)
    - _Requirements: 41.3_
  - [ ] 3.7 Integrate focus tips into AI Coach suggestions
    - _Requirements: 41.4_
  - [ ] 3.8 Add "Deep Focus" badge (10 consecutive sessions with score > 80)
    - _Requirements: 41.5_

- [ ] 4. Checkpoint — Focus Score

## Sprint 3: Smart Scheduling

- [ ] 5. Smart Scheduling (Req 39)
  - [ ] 5.1 Add `SmartScheduleTable` to Drift, run `build_runner`
  - [ ] 5.2 Create `SmartScheduleSlot` entity and `SmartScheduleRepository`
  - [ ] 5.3 Implement `ScheduleAnalyzer` — histogram-based pattern detection (30+ sessions required)
    - _Requirements: 39.1, 39.2_
  - [ ] 5.4 Integrate device calendar conflict detection
    - _Requirements: 39.3_
  - [ ] 5.5 Create `SmartScheduleBloc` with GenerateSchedule, AcceptSlot, DismissSlot events
  - [ ] 5.6 Build `SmartScheduleScreen` — weekly grid with suggested slots, accept/dismiss, confidence bars
    - _Requirements: 39.4_
  - [ ] 5.7 Auto-create reminder when user accepts a slot
    - _Requirements: 39.4_
  - [ ] 5.8 Schedule weekly re-evaluation (background task)
    - _Requirements: 39.5_
  - [ ] 5.9 Add `/smart-schedule` route and link from More screen

- [ ] 6. Checkpoint — Smart Scheduling

## Sprint 4: Predictive Goals

- [ ] 7. Predictive Goals (Req 42)
  - [ ] 7.1 Implement `GoalPredictor` service — pace ratio + trend factor algorithm
    - _Requirements: 42.1_
  - [ ] 7.2 Create `GoalPredictionCubit` — recalculate on session log
  - [ ] 7.3 Add projected trajectory line to goal progress chart
    - _Requirements: 42.3_
  - [ ] 7.4 Add completion probability badge on goal cards
    - _Requirements: 42.1_
  - [ ] 7.5 Send notification when probability drops below 50% with catch-up plan
    - _Requirements: 42.2_
  - [ ] 7.6 Integrate adaptive recommendations into AI Coach
    - _Requirements: 42.4_
  - [ ] 7.7 Auto-suggest target increase when user consistently exceeds goals
    - _Requirements: 42.5_

- [ ] 8. Checkpoint — Predictive Goals

## Sprint 5: Smart Reminders

- [ ] 9. Smart Reminders (Req 43)
  - [ ] 9.1 Implement `ReminderAnalyzer` — determine optimal reminder times from session history
    - _Requirements: 43.1_
  - [ ] 9.2 Add adaptive reminder trigger — send when user hasn't started by usual time
    - _Requirements: 43.2_
  - [ ] 9.3 Add suppression logic — skip reminder if sufficient time already logged today
    - _Requirements: 43.3_
  - [ ] 9.4 Track dismissed reminders and reduce frequency for repeatedly dismissed times
    - _Requirements: 43.4_
  - [ ] 9.5 Add per-hobby toggle: manual vs smart reminders in hobby edit screen
    - _Requirements: 43.5_
  - [ ] 9.6 Update reminder notification scheduling to use smart times when enabled

- [ ] 10. Checkpoint — Smart Reminders

## Sprint 6: Data Visualization 2.0 & Release

- [ ] 11. Data Visualization 2.0 (Req 44)
  - [ ] 11.1 Add `sankey_chart`, `radar_chart`, `screenshot` dependencies
  - [ ] 11.2 Add pinch-to-zoom and pan to existing charts (mobile), hover tooltips (desktop)
    - _Requirements: 44.1_
  - [ ] 11.3 Build Sankey diagram — days → hobbies → goals time flow
    - _Requirements: 44.2_
  - [ ] 11.4 Build radar chart — 5-axis per hobby (time, consistency, focus, mood lift, streak)
    - _Requirements: 44.3_
  - [ ] 11.5 Build comparative view — side-by-side analysis of two hobbies
    - _Requirements: 44.4_
  - [ ] 11.6 Implement chart export as PNG via share sheet
    - _Requirements: 44.5_
  - [ ] 11.7 Add screen reader descriptions and keyboard navigation to all new charts
    - _Requirements: 44.6_
  - [ ] 11.8 Optimize chart layout for web/desktop (larger format, more data density)
    - _Requirements: 44.7_
  - [ ] 11.9 Add `/advanced-viz` route accessible from Analytics screen

- [ ] 12. Checkpoint — Data Viz 2.0

- [ ] 13. Final checkpoint — v6.0.0
  - [ ] 13.1 Run full test suite, fix regressions
  - [ ] 13.2 Update README and CHANGELOG for v6.0.0
  - [ ] 13.3 Build release APK (split-per-abi)
  - [ ] 13.4 Create GitHub release with tag `v6.0.0`
