# Implementation Plan — v7.0.0 (Ecosystem)

## Overview

Builds on v1–v6 (Clean Architecture + BLoC + Drift). Adds team spaces, marketplace, public REST API, mentor mode, annual review, and advanced notifications. Transforms the app from a tool into a platform. Estimated: 12 weeks (6 sprints).

## Sprint 1: Team Spaces — Data Model & Creation

- [ ] 1. Team Spaces — Foundation (Req 45)
  - [ ] 1.1 Add `TeamSpaceTable`, `TeamMemberTable`, `TeamGoalTable` to Drift, bump schema, run `build_runner`
  - [ ] 1.2 Create `TeamSpace`, `TeamMember`, `TeamGoal`, `TeamStats` entities
  - [ ] 1.3 Implement `TeamRepository` (local Drift + Firestore) with CRUD + member management
    - _Requirements: 45.1_
  - [ ] 1.4 Create `TeamBloc` with CreateTeam, LoadTeams, AddMember, RemoveMember events
  - [ ] 1.5 Build `TeamListScreen` — my teams list, create team dialog (name, categories)
    - _Requirements: 45.1, 45.6_
  - [ ] 1.6 Enforce Premium gate for team creation, free joining
    - _Requirements: 45.6_
  - [ ] 1.7 Add Firestore rules for teams collection
  - [ ] 1.8 Add `/teams` route and link from More screen

- [ ] 2. Checkpoint — Team Spaces Foundation

## Sprint 2: Team Spaces — Dashboard & Goals

- [ ] 3. Team Spaces — Features (Req 45)
  - [ ] 3.1 Build `TeamDetailScreen` — shared dashboard with aggregated stats
    - _Requirements: 45.2_
  - [ ] 3.2 Implement team-level goals (create, track progress across members)
    - _Requirements: 45.3_
  - [ ] 3.3 Build team leaderboard with opt-in toggle per member
    - _Requirements: 45.4_
  - [ ] 3.4 Implement team announcements (admin post, all members view)
    - _Requirements: 45.5_
  - [ ] 3.5 Enforce 100-member limit and 10-team-per-user limit
    - _Requirements: 45.1, 45.7_
  - [ ] 3.6 Add `/teams/:id` route

- [ ] 4. Checkpoint — Team Spaces Complete

## Sprint 3: Marketplace

- [ ] 5. Theme & Plugin Marketplace (Req 46)
  - [ ] 5.1 Design Firestore schema for marketplace catalog (items, ratings, assets)
  - [ ] 5.2 Implement `MarketplaceRepository` — browse, install, uninstall, rate
    - _Requirements: 46.1, 46.6_
  - [ ] 5.3 Create `MarketplaceBloc` with Browse, Install, Uninstall, Rate events
  - [ ] 5.4 Build `MarketplaceScreen` — grid/list view with search, category filters, install button
    - _Requirements: 46.1_
  - [ ] 5.5 Implement theme installation — download and apply custom theme from marketplace
    - _Requirements: 46.5_
  - [ ] 5.6 Implement plugin installation — download and activate plugin
    - _Requirements: 46.5_
  - [ ] 5.7 Sync installed items across devices via cloud
    - _Requirements: 46.7_
  - [ ] 5.8 Add `/marketplace` route and link from More screen

- [ ] 6. Checkpoint — Marketplace

## Sprint 4: Public REST API

- [ ] 7. Public REST API (Req 47)
  - [ ] 7.1 Set up Firebase Cloud Functions project with TypeScript
  - [ ] 7.2 Implement API key authentication middleware
    - _Requirements: 47.3_
  - [ ] 7.3 Implement rate limiting middleware (token bucket: 100/min free, 1000/min premium)
    - _Requirements: 47.4_
  - [ ] 7.4 Implement CRUD endpoints for hobbies, sessions, goals, stats
    - _Requirements: 47.1, 47.2_
  - [ ] 7.5 Add consistent JSON error format
    - _Requirements: 47.6_
  - [ ] 7.6 Generate OpenAPI/Swagger documentation
    - _Requirements: 47.5_
  - [ ] 7.7 Add `ApiKeyTable` to Drift, create `ApiKeyRepository`
  - [ ] 7.8 Build `ApiKeysScreen` — generate, revoke, view usage
    - _Requirements: 47.7_
  - [ ] 7.9 Add `/api-keys` route in settings
  - [ ] 7.10 Deploy Cloud Functions and test end-to-end

- [ ] 8. Checkpoint — Public API

## Sprint 5: Mentor Mode & Annual Review

- [ ] 9. Mentor Mode (Req 48)
  - [ ] 9.1 Add `MentorProfileTable`, `MentorshipTable` to Drift, run `build_runner`
  - [ ] 9.2 Create `MentorProfile`, `Mentorship` entities and `MentorRepository`
  - [ ] 9.3 Create `MentorBloc` with EnableMentorMode, FindMentors, RequestMentorship events
  - [ ] 9.4 Build `FindMentorScreen` — browse mentors by category, request mentorship
    - _Requirements: 48.2, 48.3_
  - [ ] 9.5 Build `MentorDashboardScreen` — mentee list, progress, set recommended goals/routines
    - _Requirements: 48.4, 48.5_
  - [ ] 9.6 Enforce Premium gate and 10-mentee limit
    - _Requirements: 48.1, 48.6_
  - [ ] 9.7 Add mentor rating system
    - _Requirements: 48.7_
  - [ ] 9.8 Add `/mentors` and `/mentor-dashboard` routes

- [ ] 10. Annual Review (Req 49)
  - [ ] 10.1 Add `AnnualReviewTable` to Drift, run `build_runner`
  - [ ] 10.2 Create `AnnualReview` entity and `AnnualReviewRepository`
  - [ ] 10.3 Implement review data aggregation (total hours, top hobby, streak, badges, goals, monthly breakdown, mood/focus trends)
    - _Requirements: 49.2_
  - [ ] 10.4 Create `AnnualReviewCubit` — generate on demand or auto in January
    - _Requirements: 49.1_
  - [ ] 10.5 Build `AnnualReviewScreen` — animated swipeable card sequence (9 cards)
    - _Requirements: 49.3_
  - [ ] 10.6 Implement share as image series via widgets_to_image
    - _Requirements: 49.4_
  - [ ] 10.7 Store past reviews for historical viewing
    - _Requirements: 49.5_
  - [ ] 10.8 Add `/annual-review` route

- [ ] 11. Checkpoint — Mentor Mode & Annual Review

## Sprint 6: Advanced Notifications & Release

- [ ] 12. Advanced Notifications (Req 50)
  - [ ] 12.1 Implement notification quick actions — "Start Timer", "Log 30 min", "Snooze 1 hour"
    - _Requirements: 50.1_
  - [ ] 12.2 Implement notification grouping by hobby (NotificationChannel per hobby)
    - _Requirements: 50.2_
  - [ ] 12.3 Implement weekly digest notification (Sunday 7 PM, week summary)
    - _Requirements: 50.3_
  - [ ] 12.4 Implement daily throttle (max 5 notifications per day)
    - _Requirements: 50.4_
  - [ ] 12.5 Respect device Do Not Disturb settings
    - _Requirements: 50.5_
  - [ ] 12.6 Build `NotificationSettingsScreen` — configure quick actions, grouping, digest, throttle
  - [ ] 12.7 Add `/notification-settings` route in settings

- [ ] 13. Final checkpoint — v7.0.0
  - [ ] 13.1 Run full test suite, fix regressions
  - [ ] 13.2 Update README and CHANGELOG for v7.0.0
  - [ ] 13.3 Build release APK (split-per-abi)
  - [ ] 13.4 Create GitHub release with tag `v7.0.0`
