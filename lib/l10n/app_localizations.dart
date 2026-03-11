import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hobby Tracker'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get hobbies;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @activeHobbies.
  ///
  /// In en, this message translates to:
  /// **'Active Hobbies'**
  String get activeHobbies;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @recentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent Sessions'**
  String get recentSessions;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet. Add a hobby to get started!'**
  String get noDataYet;

  /// No description provided for @noHobbiesYet.
  ///
  /// In en, this message translates to:
  /// **'No hobbies yet. Add one!'**
  String get noHobbiesYet;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'No goals yet. Set one!'**
  String get noGoalsYet;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.'**
  String get noSessionsYet;

  /// No description provided for @noSessionsLogged.
  ///
  /// In en, this message translates to:
  /// **'No sessions logged yet.'**
  String get noSessionsLogged;

  /// No description provided for @noDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for this period.'**
  String get noDataForPeriod;

  /// No description provided for @addHobbyFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a hobby first.'**
  String get addHobbyFirst;

  /// No description provided for @addHobbyFirstTimer.
  ///
  /// In en, this message translates to:
  /// **'Add a hobby first to use the timer.'**
  String get addHobbyFirstTimer;

  /// No description provided for @addHobby.
  ///
  /// In en, this message translates to:
  /// **'Add Hobby'**
  String get addHobby;

  /// No description provided for @editHobby.
  ///
  /// In en, this message translates to:
  /// **'Edit Hobby'**
  String get editHobby;

  /// No description provided for @hobbyDetail.
  ///
  /// In en, this message translates to:
  /// **'Hobby Detail'**
  String get hobbyDetail;

  /// No description provided for @addGoal.
  ///
  /// In en, this message translates to:
  /// **'Add Goal'**
  String get addGoal;

  /// No description provided for @createGoal.
  ///
  /// In en, this message translates to:
  /// **'Create Goal'**
  String get createGoal;

  /// No description provided for @logSession.
  ///
  /// In en, this message translates to:
  /// **'Log Session'**
  String get logSession;

  /// No description provided for @saveSession.
  ///
  /// In en, this message translates to:
  /// **'Save Session'**
  String get saveSession;

  /// No description provided for @saveSessionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Save Session?'**
  String get saveSessionQuestion;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @endDateError.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date'**
  String get endDateError;

  /// No description provided for @ratingOptional.
  ///
  /// In en, this message translates to:
  /// **'Rating (optional)'**
  String get ratingOptional;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @noRemindersSet.
  ///
  /// In en, this message translates to:
  /// **'No reminders set. Tap + to add one.'**
  String get noRemindersSet;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Select Days'**
  String get selectDays;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @mustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Must be a positive number'**
  String get mustBePositive;

  /// No description provided for @hobby.
  ///
  /// In en, this message translates to:
  /// **'Hobby'**
  String get hobby;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @targetMinutes.
  ///
  /// In en, this message translates to:
  /// **'Target (minutes)'**
  String get targetMinutes;

  /// No description provided for @durationMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutesLabel;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @selectHobby.
  ///
  /// In en, this message translates to:
  /// **'Select Hobby'**
  String get selectHobby;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'⏱ Running'**
  String get running;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'⏸ Paused'**
  String get paused;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'Photos ({count}/5)'**
  String photosCount(int count);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {mins}m'**
  String durationHoursMinutes(int hours, int mins);

  /// No description provided for @ratingStars.
  ///
  /// In en, this message translates to:
  /// **'⭐ {rating}'**
  String ratingStars(int rating);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'🔥 {days}'**
  String streakDays(int days);

  /// No description provided for @dayStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String dayStreakCount(int days);

  /// No description provided for @percentComplete.
  ///
  /// In en, this message translates to:
  /// **'{pct}%'**
  String percentComplete(String pct);

  /// No description provided for @saveMinutesSession.
  ///
  /// In en, this message translates to:
  /// **'Save {minutes} min session?'**
  String saveMinutesSession(int minutes);

  /// No description provided for @goalDescription.
  ///
  /// In en, this message translates to:
  /// **'{type} goal — {minutes} min'**
  String goalDescription(String type, int minutes);

  /// No description provided for @unlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} / {total} unlocked'**
  String unlockedCount(int unlocked, int total);

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String unlockedOn(String date);

  /// No description provided for @reachToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Reach {threshold} {type} to unlock'**
  String reachToUnlock(int threshold, String type);

  /// No description provided for @sessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved!'**
  String get sessionSaved;

  /// No description provided for @sessionTooShort.
  ///
  /// In en, this message translates to:
  /// **'Session too short to save.'**
  String get sessionTooShort;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied'**
  String get notificationPermissionDenied;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @timePerHobby.
  ///
  /// In en, this message translates to:
  /// **'Time per Hobby'**
  String get timePerHobby;

  /// No description provided for @distribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get distribution;

  /// No description provided for @dailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Daily Activity'**
  String get dailyActivity;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @csvOrPdf.
  ///
  /// In en, this message translates to:
  /// **'CSV or PDF'**
  String get csvOrPdf;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync'**
  String get cloudSync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'✓ Sync complete'**
  String get syncComplete;

  /// No description provided for @autoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto sync'**
  String get autoSync;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInToSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to enable cloud sync'**
  String get signInToSync;

  /// No description provided for @signInAndSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in & sync your data'**
  String get signInAndSync;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update {version} available'**
  String updateAvailable(String version);

  /// No description provided for @versionAvailable.
  ///
  /// In en, this message translates to:
  /// **'{version} available'**
  String versionAvailable(String version);

  /// No description provided for @badgeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{emoji} Badge Unlocked!'**
  String badgeUnlocked(String emoji);

  /// No description provided for @youEarnedBadge.
  ///
  /// In en, this message translates to:
  /// **'You earned \"{title}\"!'**
  String youEarnedBadge(String title);

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track Your Hobbies'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Log sessions, set goals, and watch your progress grow over time.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Earn Badges & Streaks'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated with achievements, streaks, and milestone badges.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Sync & Export'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Back up to the cloud and export your data as CSV or PDF anytime.'**
  String get onboardingBody3;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @catSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get catSports;

  /// No description provided for @catMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get catMusic;

  /// No description provided for @catArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get catArt;

  /// No description provided for @catReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get catReading;

  /// No description provided for @catGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get catGaming;

  /// No description provided for @catCooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get catCooking;

  /// No description provided for @catFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get catFitness;

  /// No description provided for @catPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get catPhotography;

  /// No description provided for @catWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get catWriting;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @badge3DayStreak.
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get badge3DayStreak;

  /// No description provided for @badgeWeekWarrior.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get badgeWeekWarrior;

  /// No description provided for @badgeMonthlyMaster.
  ///
  /// In en, this message translates to:
  /// **'Monthly Master'**
  String get badgeMonthlyMaster;

  /// No description provided for @badgeCenturyClub.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get badgeCenturyClub;

  /// No description provided for @badgeFirstStep.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get badgeFirstStep;

  /// No description provided for @badgeGettingSerious.
  ///
  /// In en, this message translates to:
  /// **'Getting Serious'**
  String get badgeGettingSerious;

  /// No description provided for @badgeDedicated.
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get badgeDedicated;

  /// No description provided for @badgeCenturion.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get badgeCenturion;

  /// No description provided for @badgeFirstHour.
  ///
  /// In en, this message translates to:
  /// **'First Hour'**
  String get badgeFirstHour;

  /// No description provided for @badgeTimeInvestor.
  ///
  /// In en, this message translates to:
  /// **'Time Investor'**
  String get badgeTimeInvestor;

  /// No description provided for @badgeMasterOfTime.
  ///
  /// In en, this message translates to:
  /// **'Master of Time'**
  String get badgeMasterOfTime;

  /// No description provided for @badgeExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get badgeExplorer;

  /// No description provided for @badgeAdventurer.
  ///
  /// In en, this message translates to:
  /// **'Adventurer'**
  String get badgeAdventurer;

  /// No description provided for @badgeRenaissance.
  ///
  /// In en, this message translates to:
  /// **'Renaissance'**
  String get badgeRenaissance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
