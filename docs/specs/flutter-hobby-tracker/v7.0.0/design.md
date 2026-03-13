# Design Document — v7.0.0 (Ecosystem)

## Overview

This document describes the technical design for v7.0.0 features. The app transitions from a standalone tool to a platform with team collaboration, marketplace, public API, mentorship, and rich notifications.

## New Dependencies

```yaml
dependencies:
  # Req 45: Team Spaces
  # (built on existing Firebase + Drift)

  # Req 46: Marketplace
  # (Firebase Cloud Functions + Firestore for catalog)

  # Req 47: Public API
  # (Firebase Cloud Functions, deployed separately)

  # Req 48: Mentor Mode
  # (built on existing partner system + Firebase)

  # Req 49: Annual Review
  widgets_to_image: ^1.0.0        # render widgets as images for sharing
  lottie: ^3.0.0                  # animations for review cards

  # Req 50: Advanced Notifications
  # (built on existing flutter_local_notifications)
```

## Database Changes (Schema v9 → v10)

### New Tables

```dart
class TeamSpaceTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get creatorUid => text()();
  TextColumn get categories => text()();          // JSON array
  IntColumn get memberLimit => integer().withDefault(const Constant(100))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TeamMemberTable extends Table {
  TextColumn get id => text()();
  TextColumn get teamId => text()();
  TextColumn get userUid => text()();
  TextColumn get displayName => text()();
  TextColumn get role => text()();                // admin, member
  BoolColumn get leaderboardOptIn => boolean().withDefault(const Constant(true))();
  DateTimeColumn get joinedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TeamGoalTable extends Table {
  TextColumn get id => text()();
  TextColumn get teamId => text()();
  TextColumn get description => text()();
  IntColumn get targetMinutes => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

class MentorProfileTable extends Table {
  TextColumn get id => text()();
  TextColumn get userUid => text()();
  TextColumn get bio => text()();
  TextColumn get expertiseCategories => text()(); // JSON array
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class MentorshipTable extends Table {
  TextColumn get id => text()();
  TextColumn get mentorUid => text()();
  TextColumn get menteeUid => text()();
  TextColumn get status => text()();              // pending, active, ended
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AnnualReviewTable extends Table {
  TextColumn get id => text()();
  IntColumn get year => integer()();
  TextColumn get dataJson => text()();            // serialized review data
  DateTimeColumn get generatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ApiKeyTable extends Table {
  TextColumn get id => text()();
  TextColumn get key => text()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

## Architecture Changes

### New Entities

```dart
class TeamSpace {
  final String id;
  final String name;
  final String creatorUid;
  final List<String> categories;
  final int memberLimit;
  final bool isActive;
}

class TeamMember {
  final String id;
  final String teamId;
  final String userUid;
  final String displayName;
  final String role;           // admin, member
  final bool leaderboardOptIn;
}

class TeamGoal {
  final String id;
  final String teamId;
  final String description;
  final int targetMinutes;
  final DateTime startDate;
  final DateTime endDate;
}

class TeamStats {
  final int totalHours;
  final int activeMembers;
  final List<MapEntry<String, int>> topHobbies;  // hobby -> minutes
}

class MentorProfile {
  final String id;
  final String userUid;
  final String displayName;
  final String bio;
  final List<String> expertiseCategories;
  final double rating;
}

class Mentorship {
  final String id;
  final String mentorUid;
  final String menteeUid;
  final String status;         // pending, active, ended
}

class AnnualReview {
  final int year;
  final int totalHours;
  final String mostPracticedHobby;
  final int longestStreak;
  final int badgesEarned;
  final int goalsCompleted;
  final int goalsSet;
  final Map<int, int> monthlyMinutes;  // month -> minutes
  final List<double>? moodTrend;
  final List<double>? focusTrend;
}

class MarketplaceItem {
  final String id;
  final String name;
  final String description;
  final String type;           // theme, plugin
  final String creatorName;
  final double price;          // 0 = free
  final double rating;
  final int installCount;
  final String version;
}

class ApiKey {
  final String id;
  final String key;
  final String name;
  final bool isActive;
  final DateTime createdAt;
}
```

### New Repositories

```dart
abstract class TeamRepository {
  Future<TeamSpace> createTeam(String name, List<String> categories);
  Future<void> addMember(String teamId, String userUid);
  Future<void> removeMember(String teamId, String userUid);
  Future<List<TeamSpace>> getMyTeams();
  Future<List<TeamMember>> getTeamMembers(String teamId);
  Future<TeamStats> getTeamStats(String teamId);
  Future<void> createTeamGoal(TeamGoal goal);
  Future<void> postAnnouncement(String teamId, String message);
}

abstract class MarketplaceRepository {
  Future<List<MarketplaceItem>> browse({String? category, String? query});
  Future<void> install(String itemId);
  Future<void> uninstall(String itemId);
  Future<List<MarketplaceItem>> getInstalled();
  Future<void> rateItem(String itemId, int rating);
}

abstract class ApiKeyRepository {
  Future<ApiKey> generateKey(String name);
  Future<void> revokeKey(String keyId);
  Future<List<ApiKey>> getKeys();
}

abstract class MentorRepository {
  Future<void> enableMentorMode(MentorProfile profile);
  Future<List<MentorProfile>> findMentors({String? category});
  Future<void> requestMentorship(String mentorUid);
  Future<void> approveMentorship(String mentorshipId);
  Future<void> rejectMentorship(String mentorshipId);
  Future<void> endMentorship(String mentorshipId);
  Future<void> setRecommendedGoal(String menteeUid, Goal goal);
  Future<void> setRecommendedRoutine(String menteeUid, Routine routine);
}

abstract class AnnualReviewRepository {
  Future<AnnualReview> generateReview(int year);
  Future<AnnualReview?> getReview(int year);
  Future<List<int>> getAvailableYears();
}
```

### New BLoCs

```dart
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  // Events: CreateTeam, LoadTeams, LoadTeamDetail, AddMember, RemoveMember,
  //         CreateTeamGoal, PostAnnouncement
  // States: TeamInitial, TeamsLoaded, TeamDetailLoaded (members, stats, goals, announcements)
}

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  // Events: Browse, Install, Uninstall, Rate
  // States: MarketplaceInitial, MarketplaceLoaded (items), Installing, Installed
}

class MentorBloc extends Bloc<MentorEvent, MentorState> {
  // Events: EnableMentorMode, FindMentors, RequestMentorship, Approve, Reject,
  //         SetRecommendedGoal, SetRecommendedRoutine
  // States: MentorInitial, MentorsLoaded, MentorDashboard (mentees + stats)
}

class AnnualReviewCubit extends Cubit<AnnualReviewState> {
  // States: ReviewInitial, ReviewGenerating, ReviewLoaded (review data + card index)
}

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  // Manages quick action config, grouping, digest, throttle settings
}
```

### New Screens

```
lib/presentation/screens/
├── team_list_screen.dart         # My teams, create team
├── team_detail_screen.dart       # Members, stats, goals, leaderboard, announcements
├── marketplace_screen.dart       # Browse, search, install themes/plugins
├── api_keys_screen.dart          # Generate, revoke, view API keys
├── find_mentor_screen.dart       # Browse mentors by category
├── mentor_dashboard_screen.dart  # Mentee list, progress, set goals/routines
├── annual_review_screen.dart     # Animated swipeable card sequence
├── notification_settings_screen.dart  # Quick actions, grouping, digest, throttle
```

### Firestore Schema (new collections)

```
teams/{teamId}
  ├── name, creatorUid, categories, memberLimit, createdAt
  ├── members/{userId} — role, displayName, leaderboardOptIn, joinedAt
  ├── goals/{goalId} — description, targetMinutes, startDate, endDate
  └── announcements/{announcementId} — message, authorUid, createdAt

marketplace/{itemId}
  ├── name, description, type, creatorUid, price, version
  ├── ratings/{userId} — score, review
  └── assets/ — downloadable theme/plugin data

mentors/{userId}
  ├── bio, expertiseCategories, rating, isActive
  └── mentorships/{mentorshipId} — menteeUid, status, createdAt

api_keys/{userId}
  └── keys/{keyId} — key, name, isActive, createdAt, lastUsedAt

annual_reviews/{userId}
  └── {year} — serialized review data, generatedAt
```

### Public API Design (Cloud Functions)

```
Base URL: https://us-central1-{project}.cloudfunctions.net/api/v1

Authentication: x-api-key header

Endpoints:
  GET    /hobbies              — list user's hobbies
  GET    /hobbies/:id          — get hobby detail
  POST   /hobbies              — create hobby
  PUT    /hobbies/:id          — update hobby
  DELETE /hobbies/:id          — archive hobby

  GET    /sessions             — list sessions (query: hobbyId, startDate, endDate)
  POST   /sessions             — log session
  GET    /sessions/:id         — get session detail

  GET    /goals                — list active goals
  POST   /goals                — create goal

  GET    /stats/summary        — dashboard summary (streak, weekly, monthly)
  GET    /stats/hobby/:id      — per-hobby stats

Rate limiting: Token bucket (100/min free, 1000/min premium)
Error format: { "error": { "code": "NOT_FOUND", "message": "..." } }
```

### Advanced Notification Architecture

```
Notification Actions (Android):
  - PendingIntent for "Start Timer" → launches app with timer deep link
  - PendingIntent for "Log 30 min" → background service logs session
  - PendingIntent for "Snooze 1 hour" → reschedules notification

Grouping:
  - NotificationChannel per hobby
  - Summary notification when 3+ from same hobby

Weekly Digest:
  - Scheduled for Sunday 7 PM local time
  - BigTextStyle with week summary (total hours, streak, top hobby)

Throttle:
  - Counter in SharedPreferences, reset daily at midnight
  - Skip notification if counter >= 5
```

### Annual Review Card Sequence

```
Card 1: "Your Year in Review" — title + year + total hours (animated counter)
Card 2: "Most Practiced" — hobby name + hours + emoji (scale animation)
Card 3: "Streak Champion" — longest streak + calendar visualization
Card 4: "Badges Earned" — badge grid with unlock animations
Card 5: "Goals" — completed/set ratio + confetti if > 80%
Card 6: "Month by Month" — bar chart animation (bars grow sequentially)
Card 7: "Mood Journey" — mood trend line (if tracked) with highlights
Card 8: "Focus Growth" — focus score trend (if tracked)
Card 9: "Share Your Journey" — share button → generates image series
```
