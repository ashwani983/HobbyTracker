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

## Notes

- i18n should be done first since all subsequent features need localized strings
- AI suggestions use simple heuristics, not ML models — keep it lightweight
- Home screen widgets require native platform code (Kotlin/Swift)
- Test sharing on real devices — screenshot package needs GPU context
