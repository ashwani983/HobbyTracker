import '../l10n/app_localizations.dart';

/// Maps English DB-stored category names to localized display strings.
Map<String, String> localizedCategories(AppLocalizations l) => {
  'Sports': l.catSports,
  'Music': l.catMusic,
  'Art': l.catArt,
  'Reading': l.catReading,
  'Gaming': l.catGaming,
  'Cooking': l.catCooking,
  'Fitness': l.catFitness,
  'Photography': l.catPhotography,
  'Writing': l.catWriting,
  'Other': l.catOther,
};

/// Maps badge id to localized title.
Map<String, String> localizedBadgeTitles(AppLocalizations l) => {
  'streak_3': l.badge3DayStreak,
  'streak_7': l.badgeWeekWarrior,
  'streak_30': l.badgeMonthlyMaster,
  'streak_100': l.badgeCenturyClub,
  'milestone_1': l.badgeFirstStep,
  'milestone_10': l.badgeGettingSerious,
  'milestone_50': l.badgeDedicated,
  'milestone_100': l.badgeCenturion,
  'time_60': l.badgeFirstHour,
  'time_600': l.badgeTimeInvestor,
  'time_6000': l.badgeMasterOfTime,
  'explorer_3': l.badgeExplorer,
  'explorer_5': l.badgeAdventurer,
  'explorer_10': l.badgeRenaissance,
};

/// Localized day abbreviations (index 0 = Mon, 6 = Sun).
List<String> localizedDayNames(AppLocalizations l) => [
  l.dayMon, l.dayTue, l.dayWed, l.dayThu, l.dayFri, l.daySat, l.daySun,
];
