// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi de Loisirs';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get hobbies => 'Loisirs';

  @override
  String get timer => 'Minuteur';

  @override
  String get goals => 'Objectifs';

  @override
  String get stats => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get activeHobbies => 'Loisirs Actifs';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get dayStreak => 'Jours Consécutifs';

  @override
  String get recentSessions => 'Sessions Récentes';

  @override
  String get noDataYet =>
      'Pas encore de données. Ajoutez un loisir pour commencer !';

  @override
  String get noHobbiesYet => 'Pas encore de loisirs. Ajoutez-en un !';

  @override
  String get noGoalsYet => 'Pas encore d\'objectifs. Définissez-en un !';

  @override
  String get noSessionsYet => 'Pas encore de sessions.';

  @override
  String get noSessionsLogged => 'Aucune session enregistrée.';

  @override
  String get noDataForPeriod => 'Pas de données pour cette période.';

  @override
  String get addHobbyFirst => 'Ajoutez d\'abord un loisir.';

  @override
  String get addHobbyFirstTimer =>
      'Ajoutez d\'abord un loisir pour utiliser le minuteur.';

  @override
  String get addHobby => 'Ajouter un Loisir';

  @override
  String get editHobby => 'Modifier le Loisir';

  @override
  String get hobbyDetail => 'Détail du Loisir';

  @override
  String get addGoal => 'Ajouter un Objectif';

  @override
  String get createGoal => 'Créer un Objectif';

  @override
  String get logSession => 'Enregistrer une Session';

  @override
  String get saveSession => 'Sauvegarder la Session';

  @override
  String get saveSessionQuestion => 'Sauvegarder la Session ?';

  @override
  String get create => 'Créer';

  @override
  String get save => 'Sauvegarder';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get skip => 'Passer';

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get discard => 'Abandonner';

  @override
  String get later => 'Plus tard';

  @override
  String get update => 'Mettre à jour';

  @override
  String get about => 'À propos';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Description';

  @override
  String get category => 'Catégorie';

  @override
  String get color => 'Couleur';

  @override
  String get date => 'Date';

  @override
  String get startDate => 'Date de Début';

  @override
  String get endDate => 'Date de Fin';

  @override
  String get endDateError =>
      'La date de fin doit être postérieure à la date de début';

  @override
  String get ratingOptional => 'Note (optionnel)';

  @override
  String get sessions => 'Sessions';

  @override
  String get reminders => 'Rappels';

  @override
  String get noRemindersSet =>
      'Aucun rappel défini. Appuyez sur + pour en ajouter.';

  @override
  String get selectDays => 'Sélectionner les Jours';

  @override
  String get nameRequired => 'Le nom est obligatoire';

  @override
  String get required => 'Obligatoire';

  @override
  String get mustBePositive => 'Doit être un nombre positif';

  @override
  String get hobby => 'Loisir';

  @override
  String get type => 'Type';

  @override
  String get targetMinutes => 'Objectif (minutes)';

  @override
  String get durationMinutesLabel => 'Durée (minutes)';

  @override
  String get notes => 'Notes';

  @override
  String get selectHobby => 'Sélectionner un Loisir';

  @override
  String get allTime => 'Tout le temps';

  @override
  String get archive => 'Archiver';

  @override
  String get running => '⏱ En cours';

  @override
  String get paused => '⏸ En pause';

  @override
  String get toggleTheme => 'Changer le thème';

  @override
  String get camera => 'Appareil photo';

  @override
  String get gallery => 'Galerie';

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
    return 'Série de $days jours';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return 'Sauvegarder la session de $minutes min ?';
  }

  @override
  String goalDescription(String type, int minutes) {
    return 'Objectif $type — $minutes min';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total débloqués';
  }

  @override
  String unlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return 'Atteignez $threshold $type pour débloquer';
  }

  @override
  String get sessionSaved => 'Session sauvegardée !';

  @override
  String get sessionTooShort => 'Session trop courte pour être sauvegardée.';

  @override
  String get notificationPermissionDenied =>
      'Permission de notification refusée';

  @override
  String exportFailed(String error) {
    return 'Échec de l\'export : $error';
  }

  @override
  String get timePerHobby => 'Temps par Loisir';

  @override
  String get distribution => 'Répartition';

  @override
  String get dailyActivity => 'Activité Quotidienne';

  @override
  String get theme => 'Thème';

  @override
  String get badges => 'Badges';

  @override
  String get exportData => 'Exporter les Données';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportPdf => 'Exporter PDF';

  @override
  String get csvOrPdf => 'CSV ou PDF';

  @override
  String get cloudSync => 'Synchronisation Cloud';

  @override
  String get syncNow => 'Synchroniser';

  @override
  String get syncing => 'Synchronisation...';

  @override
  String get syncComplete => '✓ Synchronisation terminée';

  @override
  String get autoSync => 'Synchronisation automatique';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInToSync => 'Connectez-vous pour activer la synchronisation';

  @override
  String get signInAndSync => 'Connectez-vous et synchronisez vos données';

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get user => 'Utilisateur';

  @override
  String get termsAndConditions => 'Conditions Générales';

  @override
  String get checkForUpdates => 'Vérifier les Mises à Jour';

  @override
  String get checking => 'Vérification...';

  @override
  String updateAvailable(String version) {
    return 'Mise à jour $version disponible';
  }

  @override
  String versionAvailable(String version) {
    return '$version disponible';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '$emoji Badge Débloqué !';
  }

  @override
  String youEarnedBadge(String title) {
    return 'Vous avez gagné \"$title\" !';
  }

  @override
  String get awesome => 'Super !';

  @override
  String get onboardingTitle1 => 'Suivez Vos Loisirs';

  @override
  String get onboardingBody1 =>
      'Enregistrez des sessions, fixez des objectifs et suivez vos progrès.';

  @override
  String get onboardingTitle2 => 'Gagnez des Badges et Séries';

  @override
  String get onboardingBody2 =>
      'Restez motivé avec des réalisations, séries et badges.';

  @override
  String get onboardingTitle3 => 'Synchronisez et Exportez';

  @override
  String get onboardingBody3 =>
      'Sauvegardez dans le cloud et exportez vos données en CSV ou PDF.';

  @override
  String get language => 'Langue';

  @override
  String get week => 'Semaine';

  @override
  String get month => 'Mois';

  @override
  String get year => 'Année';
}
