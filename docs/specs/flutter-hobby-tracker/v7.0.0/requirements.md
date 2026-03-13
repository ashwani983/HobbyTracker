# Requirements Document — v7.0.0 (Ecosystem)

## Introduction

Version 7.0.0 transforms the app from a standalone tool into a platform. Team collaboration, a marketplace for community-created themes and plugins, a public REST API, mentorship features, annual reviews, and advanced notifications. All v1–v6 features remain intact.

## Glossary

- **Team Space**: A shared workspace where groups track hobbies together with aggregated stats and team goals
- **Marketplace**: An in-app store for community-created themes and plugins
- **Public API**: A RESTful interface allowing developers to access their hobby data programmatically
- **Mentor Mode**: A feature allowing experienced users to guide beginners with recommended goals and routines
- **Annual Review**: An animated year-in-review summary of the user's hobby journey

## Requirements

### Requirement 45: Team Spaces

**User Story:** As a team lead, I want to create shared spaces where groups can track hobbies together, so that we can build team culture around learning.

#### Acceptance Criteria

1. WHEN a user creates a Team Space, THE App SHALL allow naming it, adding members (up to 100), and selecting shared hobby categories
2. Team members SHALL see a shared dashboard with aggregated team stats (total hours, active members, top hobbies)
3. THE App SHALL support team-level goals (e.g., "Team logs 100 hours of reading this month")
4. THE App SHALL display a team leaderboard (opt-in per member)
5. Team admins SHALL be able to post announcements visible to all members
6. THE App SHALL require Premium subscription for Team Space creation (joining is free)
7. THE App SHALL support up to 10 Team Spaces per Premium user

---

### Requirement 46: Theme & Plugin Marketplace

**User Story:** As a user, I want to browse and install community-created themes and plugins.

#### Acceptance Criteria

1. THE App SHALL provide a Marketplace screen listing community themes and plugins with search and category filters
2. Themes and plugins SHALL be reviewed and approved before listing
3. THE App SHALL support free and paid marketplace items (revenue share: 70/30 creator/platform)
4. Creators SHALL submit items via a web portal with documentation and screenshots
5. THE App SHALL handle marketplace item updates and versioning
6. THE App SHALL allow users to rate and review marketplace items
7. Installed items SHALL be synced across devices via cloud

---

### Requirement 47: Public REST API

**User Story:** As a developer, I want a public API to access my hobby data, so that I can build custom integrations and dashboards.

#### Acceptance Criteria

1. THE App SHALL expose a RESTful API via Firebase Cloud Functions
2. THE API SHALL support CRUD operations for hobbies, sessions, goals, and stats
3. THE API SHALL require authentication via API key linked to the user's account
4. THE API SHALL enforce rate limits (100 requests/minute for free, 1000 for premium)
5. THE API SHALL include OpenAPI/Swagger documentation
6. THE API SHALL return JSON responses with consistent error formats
7. THE App SHALL provide an API key management screen in settings (generate, revoke, view usage)

---

### Requirement 48: Mentor Mode

**User Story:** As an experienced hobbyist, I want to mentor beginners, so that I can share knowledge and track their progress.

#### Acceptance Criteria

1. THE App SHALL allow Premium users to enable "Mentor Mode" and create a public profile with bio and hobby expertise
2. Mentors SHALL be discoverable by hobby category in a "Find a Mentor" screen
3. WHEN a mentee requests mentorship, THE mentor SHALL approve/reject the request
4. Mentors SHALL see mentee progress dashboards (aggregate stats, goal completion, streak)
5. Mentors SHALL be able to set recommended goals and routines for mentees
6. THE App SHALL limit each mentor to 10 active mentees
7. Mentees SHALL be able to rate their mentor experience

---

### Requirement 49: Annual Review

**User Story:** As a user, I want a beautiful year-in-review summary, so that I can reflect on my hobby journey.

#### Acceptance Criteria

1. THE App SHALL generate an Annual Review in January (or on demand) for the previous year
2. THE Annual Review SHALL include:
   - Total hours across all hobbies
   - Most practiced hobby
   - Longest streak
   - Badges earned
   - Goals completed vs. set
   - Month-by-month breakdown
   - Mood trends (if tracked)
   - Focus score trends (if tracked)
3. THE Annual Review SHALL be presented as an animated, swipeable card sequence
4. THE App SHALL allow sharing the Annual Review as an image series
5. THE App SHALL store past Annual Reviews for historical viewing

---

### Requirement 50: Advanced Notifications

**User Story:** As a user, I want rich, actionable notifications that help me stay on track without opening the app.

#### Acceptance Criteria

1. Notifications SHALL support quick actions:
   - "Start Timer" directly from notification
   - "Log 30 min" quick-log without opening app
   - "Snooze 1 hour"
2. THE App SHALL support notification grouping by hobby
3. THE App SHALL support weekly digest notifications (Sunday evening summary)
4. THE App SHALL intelligently throttle notifications (max 5 per day)
5. THE App SHALL respect device Do Not Disturb settings
