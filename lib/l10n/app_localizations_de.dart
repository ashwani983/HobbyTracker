// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Hobby-Tracker';

  @override
  String get dashboard => 'Übersicht';

  @override
  String get hobbies => 'Hobbys';

  @override
  String get timer => 'Timer';

  @override
  String get goals => 'Ziele';

  @override
  String get stats => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get activeHobbies => 'Aktive Hobbys';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get dayStreak => 'Tage-Serie';

  @override
  String get recentSessions => 'Letzte Sitzungen';

  @override
  String get noDataYet => 'Noch keine Daten. Füge ein Hobby hinzu!';

  @override
  String get noHobbiesYet => 'Noch keine Hobbys. Füge eins hinzu!';

  @override
  String get noGoalsYet => 'Noch keine Ziele. Setze eins!';

  @override
  String get noSessionsYet => 'Noch keine Sitzungen.';

  @override
  String get noSessionsLogged => 'Noch keine Sitzungen erfasst.';

  @override
  String get noDataForPeriod => 'Keine Daten für diesen Zeitraum.';

  @override
  String get addHobbyFirst => 'Füge zuerst ein Hobby hinzu.';

  @override
  String get addHobbyFirstTimer =>
      'Füge zuerst ein Hobby hinzu, um den Timer zu nutzen.';

  @override
  String get addHobby => 'Hobby Hinzufügen';

  @override
  String get editHobby => 'Hobby Bearbeiten';

  @override
  String get hobbyDetail => 'Hobby-Detail';

  @override
  String get addGoal => 'Ziel Hinzufügen';

  @override
  String get createGoal => 'Ziel Erstellen';

  @override
  String get logSession => 'Sitzung Erfassen';

  @override
  String get saveSession => 'Sitzung Speichern';

  @override
  String get saveSessionQuestion => 'Sitzung Speichern?';

  @override
  String get create => 'Erstellen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get skip => 'Überspringen';

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get discard => 'Verwerfen';

  @override
  String get later => 'Später';

  @override
  String get update => 'Aktualisieren';

  @override
  String get about => 'Über';

  @override
  String get next => 'Weiter';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get category => 'Kategorie';

  @override
  String get color => 'Farbe';

  @override
  String get date => 'Datum';

  @override
  String get startDate => 'Startdatum';

  @override
  String get endDate => 'Enddatum';

  @override
  String get endDateError => 'Das Enddatum muss nach dem Startdatum liegen';

  @override
  String get ratingOptional => 'Bewertung (optional)';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get noRemindersSet =>
      'Keine Erinnerungen. Tippe auf + zum Hinzufügen.';

  @override
  String get selectDays => 'Tage Auswählen';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get required => 'Erforderlich';

  @override
  String get mustBePositive => 'Muss eine positive Zahl sein';

  @override
  String get hobby => 'Hobby';

  @override
  String get type => 'Typ';

  @override
  String get targetMinutes => 'Ziel (Minuten)';

  @override
  String get durationMinutesLabel => 'Dauer (Minuten)';

  @override
  String get notes => 'Notizen';

  @override
  String get selectHobby => 'Hobby Auswählen';

  @override
  String get allTime => 'Gesamte Zeit';

  @override
  String get archive => 'Archivieren';

  @override
  String get running => '⏱ Läuft';

  @override
  String get paused => '⏸ Pausiert';

  @override
  String get toggleTheme => 'Thema wechseln';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String photosCount(int count) {
    return 'Fotos ($count/5)';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes Min';
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
    return '$days Tage Serie';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return '$minutes Min Sitzung speichern?';
  }

  @override
  String goalDescription(String type, int minutes) {
    return '$type-Ziel — $minutes Min';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total freigeschaltet';
  }

  @override
  String unlockedOn(String date) {
    return 'Freigeschaltet am $date';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return 'Erreiche $threshold $type zum Freischalten';
  }

  @override
  String get sessionSaved => 'Sitzung gespeichert!';

  @override
  String get sessionTooShort => 'Sitzung zu kurz zum Speichern.';

  @override
  String get notificationPermissionDenied =>
      'Benachrichtigungsberechtigung verweigert';

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get timePerHobby => 'Zeit pro Hobby';

  @override
  String get distribution => 'Verteilung';

  @override
  String get dailyActivity => 'Tägliche Aktivität';

  @override
  String get theme => 'Thema';

  @override
  String get badges => 'Abzeichen';

  @override
  String get exportData => 'Daten Exportieren';

  @override
  String get exportCsv => 'CSV Exportieren';

  @override
  String get exportPdf => 'PDF Exportieren';

  @override
  String get csvOrPdf => 'CSV oder PDF';

  @override
  String get cloudSync => 'Cloud-Synchronisierung';

  @override
  String get syncNow => 'Jetzt Synchronisieren';

  @override
  String get syncing => 'Synchronisiere...';

  @override
  String get syncComplete => '✓ Synchronisierung abgeschlossen';

  @override
  String get autoSync => 'Automatische Synchronisierung';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get signInToSync =>
      'Melde dich an, um die Synchronisierung zu aktivieren';

  @override
  String get signInAndSync => 'Anmelden und Daten synchronisieren';

  @override
  String get signOut => 'Abmelden';

  @override
  String get user => 'Benutzer';

  @override
  String get termsAndConditions => 'Nutzungsbedingungen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checking => 'Prüfe...';

  @override
  String updateAvailable(String version) {
    return 'Update $version verfügbar';
  }

  @override
  String versionAvailable(String version) {
    return '$version verfügbar';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '$emoji Abzeichen Freigeschaltet!';
  }

  @override
  String youEarnedBadge(String title) {
    return 'Du hast \"$title\" verdient!';
  }

  @override
  String get awesome => 'Super!';

  @override
  String get onboardingTitle1 => 'Verfolge Deine Hobbys';

  @override
  String get onboardingBody1 =>
      'Erfasse Sitzungen, setze Ziele und beobachte deinen Fortschritt.';

  @override
  String get onboardingTitle2 => 'Verdiene Abzeichen und Serien';

  @override
  String get onboardingBody2 =>
      'Bleib motiviert mit Erfolgen, Serien und Meilenstein-Abzeichen.';

  @override
  String get onboardingTitle3 => 'Synchronisiere und Exportiere';

  @override
  String get onboardingBody3 =>
      'Sichere in der Cloud und exportiere deine Daten als CSV oder PDF.';

  @override
  String get language => 'Sprache';

  @override
  String get week => 'Woche';

  @override
  String get month => 'Monat';

  @override
  String get year => 'Jahr';
}
