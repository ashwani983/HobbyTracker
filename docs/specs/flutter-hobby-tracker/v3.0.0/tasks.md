# Implementation Plan — v3.0.0 (Advanced)

## Overview

Social sharing, AI suggestions, home screen widgets, and multi-language support. Builds on v2.0.0. Estimated: 4 weeks.

## Tasks

- [x] 1. Internationalization (i18n)
  - [x] 1.1 Set up Flutter l10n with ARB files
    - Create l10n.yaml config and lib/l10n/ directory
    - Create app_en.arb as base template with all user-facing strings
    - _Requirements: 20.2_
  - [x] 1.2 Create translation files
    - app_es.arb (Spanish), app_fr.arb (French), app_de.arb (German), app_ja.arb (Japanese), app_hi.arb (Hindi)
    - _Requirements: 20.1_
  - [x] 1.3 Replace all hardcoded strings with AppLocalizations references
    - All screens, widgets, error messages, button labels
    - _Requirements: 20.2_
  - [x] 1.4 Implement LocaleCubit with manual override
    - Detect device locale, allow override in settings, persist preference
    - _Requirements: 20.3, 20.4_
  - [x] 1.5 Ensure date/number formatting respects locale
    - _Requirements: 20.5_
  - [x] 1.6 Add language selector to settings screen
    - _Requirements: 20.4_

- [x] 2. Checkpoint — i18n

- [x] 3. Social sharing
  - [x] 3.1 Create ShareProgressCard data model
    - _Requirements: 17.2_
  - [x] 3.2 Implement GenerateShareCard use case
    - Render styled widget to image using screenshot package
    - _Requirements: 17.1_
  - [x] 3.3 Create share card widget with hobby stats and badge
    - _Requirements: 17.2_
  - [x] 3.4 Add "Share" button to hobby detail and badge screens
    - Present system share sheet with generated image
    - _Requirements: 17.1, 17.3, 17.4_

- [x] 4. Checkpoint — Sharing

- [x] 5. AI suggestions
  - [x] 5.1 Implement SuggestionEngine
    - Analyze session timestamps for optimal practice windows
    - Suggest complementary categories based on existing hobbies
    - All on-device, no external API calls
    - _Requirements: 18.1, 18.2, 18.4_
  - [x] 5.2 Create Suggestion entity and SuggestionCubit
    - Load suggestions, dismiss suggestions, persist dismissed IDs
    - _Requirements: 18.3, 18.5_
  - [x] 5.3 Add suggestion cards to dashboard
    - Dismissible cards below summary, only shown after 20+ sessions
    - _Requirements: 18.1, 18.3_

- [x] 6. Checkpoint — AI Suggestions

- [x] 7. Home screen widgets
  - [x] 7.1 Add home_widget dependency and configure native setup
    - Android: create widget layout XML and provider
    - iOS: create WidgetKit extension
    - _Requirements: 19.5_
  - [x] 7.2 Implement small widget (today's time + streak)
    - _Requirements: 19.1_
  - [x] 7.3 Implement medium widget (top 3 hobbies with weekly time)
    - _Requirements: 19.2_
  - [x] 7.4 Write widget data on each session log
    - _Requirements: 19.4_
  - [x] 7.5 Handle widget tap — deep link to dashboard
    - _Requirements: 19.3_

- [x] 8. Checkpoint — Widgets

- [ ] 9. Polish and release
  - [ ] 9.1 Update README and CHANGELOG for v3.0.0
  - [ ] 9.2 Run full test suite and analysis
  - [ ] 9.3 Test on multiple locales and device sizes

- [ ] 10. Final checkpoint
  - Ensure all tests pass, all analysis clean, ask user if questions arise.

- [ ] 11. Timer meeting notes + Goal bug fixes
  - [ ] 11.1 Add nullable `notes` column to sessions Drift table (migration)
    - _Requirements: 21.2_
  - [ ] 11.2 Update Session entity and log_session use case to accept notes
    - _Requirements: 21.2_
  - [ ] 11.3 Add optional notes TextField to timer save dialog
    - _Requirements: 21.1_
  - [ ] 11.4 Show hobby name on goals list (resolve hobbyId → name)
    - _Requirements: 24.1_
  - [ ] 11.5 Add `updateGoal` to GoalRepository and Drift DAO
    - _Requirements: 24.4_
  - [ ] 11.6 Convert AddGoalScreen to AddEditGoalScreen with edit mode
    - _Requirements: 24.2, 24.3_

- [ ] 12. Checkpoint — Notes & Goal fixes

- [ ] 13. Dashboard redesign + Per-hobby widget
  - [ ] 13.1 Replace recent sessions with per-hobby stat cards on dashboard
    - _Requirements: 23.1, 23.2_
  - [ ] 13.2 Add history icon to Hobbies tab with session history view
    - _Requirements: 23.3_
  - [ ] 13.3 Create per-hobby configurable home screen widget (Android)
    - _Requirements: 22.1, 22.2, 22.3, 22.4_

- [ ] 14. Checkpoint — Dashboard & Widget

- [ ] 15. Interactive charts and insights
  - [ ] 15.1 Add touch interaction to pie chart with hobby name labels
    - _Requirements: 25.1, 25.2, 25.4_
  - [ ] 15.2 Add touch interaction to bar chart and line chart
    - _Requirements: 25.2_
  - [ ] 15.3 Add "Best Day" and "Most Active Hobby" insight cards to stats
    - _Requirements: 25.3_

- [ ] 16. Checkpoint — Charts

- [ ] 17. Final polish and release
  - [ ] 17.1 Update README and CHANGELOG for v3.0.0
  - [ ] 17.2 Run full test suite and analysis
  - [ ] 17.3 Test on device — all new features

- [ ] 18. Final checkpoint
  - Ensure all tests pass, all analysis clean, ask user if questions arise.

## Notes

- i18n should be done first since all subsequent features need localized strings
- AI suggestions use simple heuristics, not ML models — keep it lightweight
- Home screen widgets require native platform code (Kotlin/Swift)
- Test sharing on real devices — screenshot package needs GPU context
- Goal edit reuses AddGoalScreen — pass existing Goal to pre-fill fields
- Dashboard redesign removes recent sessions — session history moves to Hobbies tab
- Charts use fl_chart touch callbacks — no new dependencies needed
- Session notes migration must be backward-compatible (nullable column)
