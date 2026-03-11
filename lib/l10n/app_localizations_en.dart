// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hobby Tracker';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get hobbies => 'Hobbies';

  @override
  String get timer => 'Timer';

  @override
  String get goals => 'Goals';

  @override
  String get stats => 'Stats';

  @override
  String get settings => 'Settings';

  @override
  String get activeHobbies => 'Active Hobbies';

  @override
  String get thisWeek => 'This Week';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get recentSessions => 'Recent Sessions';

  @override
  String get noDataYet => 'No data yet. Add a hobby to get started!';

  @override
  String get noHobbiesYet => 'No hobbies yet. Add one!';

  @override
  String get noGoalsYet => 'No goals yet. Set one!';

  @override
  String get noSessionsYet => 'No sessions yet.';

  @override
  String get noSessionsLogged => 'No sessions logged yet.';

  @override
  String get noDataForPeriod => 'No data for this period.';

  @override
  String get addHobbyFirst => 'Add a hobby first.';

  @override
  String get addHobbyFirstTimer => 'Add a hobby first to use the timer.';

  @override
  String get addHobby => 'Add Hobby';

  @override
  String get editHobby => 'Edit Hobby';

  @override
  String get hobbyDetail => 'Hobby Detail';

  @override
  String get addGoal => 'Add Goal';

  @override
  String get createGoal => 'Create Goal';

  @override
  String get logSession => 'Log Session';

  @override
  String get saveSession => 'Save Session';

  @override
  String get saveSessionQuestion => 'Save Session?';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get reset => 'Reset';

  @override
  String get discard => 'Discard';

  @override
  String get later => 'Later';

  @override
  String get update => 'Update';

  @override
  String get about => 'About';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get color => 'Color';

  @override
  String get date => 'Date';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get endDateError => 'End date must be after start date';

  @override
  String get ratingOptional => 'Rating (optional)';

  @override
  String get sessions => 'Sessions';

  @override
  String get reminders => 'Reminders';

  @override
  String get noRemindersSet => 'No reminders set. Tap + to add one.';

  @override
  String get selectDays => 'Select Days';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get required => 'Required';

  @override
  String get mustBePositive => 'Must be a positive number';

  @override
  String get hobby => 'Hobby';

  @override
  String get type => 'Type';

  @override
  String get targetMinutes => 'Target (minutes)';

  @override
  String get durationMinutesLabel => 'Duration (minutes)';

  @override
  String get notes => 'Notes';

  @override
  String get selectHobby => 'Select Hobby';

  @override
  String get allTime => 'All time';

  @override
  String get archive => 'Archive';

  @override
  String get running => '⏱ Running';

  @override
  String get paused => '⏸ Paused';

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String photosCount(int count) {
    return 'Photos ($count/5)';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String durationHoursMinutes(int hours, int mins) {
    return '${hours}h ${mins}m';
  }

  @override
  String ratingStars(int rating) {
    return '⭐ $rating';
  }

  @override
  String streakDays(int days) {
    return '🔥 $days';
  }

  @override
  String dayStreakCount(int days) {
    return '$days day streak';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return 'Save $minutes min session?';
  }

  @override
  String goalDescription(String type, int minutes) {
    return '$type goal — $minutes min';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total unlocked';
  }

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return 'Reach $threshold $type to unlock';
  }

  @override
  String get sessionSaved => 'Session saved!';

  @override
  String get sessionTooShort => 'Session too short to save.';

  @override
  String get notificationPermissionDenied => 'Notification permission denied';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get timePerHobby => 'Time per Hobby';

  @override
  String get distribution => 'Distribution';

  @override
  String get dailyActivity => 'Daily Activity';

  @override
  String get theme => 'Theme';

  @override
  String get badges => 'Badges';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get csvOrPdf => 'CSV or PDF';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncing => 'Syncing...';

  @override
  String get syncComplete => '✓ Sync complete';

  @override
  String get autoSync => 'Auto sync';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInToSync => 'Sign in to enable cloud sync';

  @override
  String get signInAndSync => 'Sign in & sync your data';

  @override
  String get signOut => 'Sign Out';

  @override
  String get user => 'User';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checking => 'Checking...';

  @override
  String updateAvailable(String version) {
    return 'Update $version available';
  }

  @override
  String versionAvailable(String version) {
    return '$version available';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '$emoji Badge Unlocked!';
  }

  @override
  String youEarnedBadge(String title) {
    return 'You earned \"$title\"!';
  }

  @override
  String get awesome => 'Awesome!';

  @override
  String get onboardingTitle1 => 'Track Your Hobbies';

  @override
  String get onboardingBody1 =>
      'Log sessions, set goals, and watch your progress grow over time.';

  @override
  String get onboardingTitle2 => 'Earn Badges & Streaks';

  @override
  String get onboardingBody2 =>
      'Stay motivated with achievements, streaks, and milestone badges.';

  @override
  String get onboardingTitle3 => 'Sync & Export';

  @override
  String get onboardingBody3 =>
      'Back up to the cloud and export your data as CSV or PDF anytime.';

  @override
  String get language => 'Language';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';
}
