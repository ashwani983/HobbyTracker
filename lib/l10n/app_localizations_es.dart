// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Rastreador de Hobbies';

  @override
  String get dashboard => 'Panel';

  @override
  String get hobbies => 'Hobbies';

  @override
  String get timer => 'Temporizador';

  @override
  String get goals => 'Metas';

  @override
  String get stats => 'Estadísticas';

  @override
  String get settings => 'Ajustes';

  @override
  String get activeHobbies => 'Hobbies Activos';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get dayStreak => 'Racha de Días';

  @override
  String get recentSessions => 'Sesiones Recientes';

  @override
  String get noDataYet => 'Sin datos aún. ¡Añade un hobby para empezar!';

  @override
  String get noHobbiesYet => 'Sin hobbies aún. ¡Añade uno!';

  @override
  String get noGoalsYet => 'Sin metas aún. ¡Establece una!';

  @override
  String get noSessionsYet => 'Sin sesiones aún.';

  @override
  String get noSessionsLogged => 'Sin sesiones registradas aún.';

  @override
  String get noDataForPeriod => 'Sin datos para este período.';

  @override
  String get addHobbyFirst => 'Añade un hobby primero.';

  @override
  String get addHobbyFirstTimer =>
      'Añade un hobby primero para usar el temporizador.';

  @override
  String get addHobby => 'Añadir Hobby';

  @override
  String get editHobby => 'Editar Hobby';

  @override
  String get hobbyDetail => 'Detalle del Hobby';

  @override
  String get addGoal => 'Añadir Meta';

  @override
  String get createGoal => 'Crear Meta';

  @override
  String get logSession => 'Registrar Sesión';

  @override
  String get saveSession => 'Guardar Sesión';

  @override
  String get saveSessionQuestion => '¿Guardar Sesión?';

  @override
  String get create => 'Crear';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get skip => 'Omitir';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reanudar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get discard => 'Descartar';

  @override
  String get later => 'Después';

  @override
  String get update => 'Actualizar';

  @override
  String get about => 'Acerca de';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get name => 'Nombre';

  @override
  String get description => 'Descripción';

  @override
  String get category => 'Categoría';

  @override
  String get color => 'Color';

  @override
  String get date => 'Fecha';

  @override
  String get startDate => 'Fecha de Inicio';

  @override
  String get endDate => 'Fecha de Fin';

  @override
  String get endDateError =>
      'La fecha de fin debe ser posterior a la de inicio';

  @override
  String get ratingOptional => 'Calificación (opcional)';

  @override
  String get sessions => 'Sesiones';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get noRemindersSet => 'Sin recordatorios. Toca + para añadir uno.';

  @override
  String get selectDays => 'Seleccionar Días';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get required => 'Obligatorio';

  @override
  String get mustBePositive => 'Debe ser un número positivo';

  @override
  String get hobby => 'Hobby';

  @override
  String get type => 'Tipo';

  @override
  String get targetMinutes => 'Objetivo (minutos)';

  @override
  String get durationMinutesLabel => 'Duración (minutos)';

  @override
  String get notes => 'Notas';

  @override
  String get selectHobby => 'Seleccionar Hobby';

  @override
  String get allTime => 'Todo el tiempo';

  @override
  String get archive => 'Archivar';

  @override
  String get running => '⏱ En marcha';

  @override
  String get paused => '⏸ Pausado';

  @override
  String get toggleTheme => 'Cambiar tema';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String photosCount(int count) {
    return 'Fotos ($count/5)';
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
    return 'Racha de $days días';
  }

  @override
  String percentComplete(String pct) {
    return '$pct%';
  }

  @override
  String saveMinutesSession(int minutes) {
    return '¿Guardar sesión de $minutes min?';
  }

  @override
  String goalDescription(String type, int minutes) {
    return 'Meta $type — $minutes min';
  }

  @override
  String unlockedCount(int unlocked, int total) {
    return '$unlocked / $total desbloqueados';
  }

  @override
  String unlockedOn(String date) {
    return 'Desbloqueado el $date';
  }

  @override
  String reachToUnlock(int threshold, String type) {
    return 'Alcanza $threshold $type para desbloquear';
  }

  @override
  String get sessionSaved => '¡Sesión guardada!';

  @override
  String get sessionTooShort => 'Sesión demasiado corta para guardar.';

  @override
  String get notesHint => '¿En qué trabajaste?';

  @override
  String get editGoal => 'Editar meta';

  @override
  String get updateGoal => 'Actualizar meta';

  @override
  String get notificationPermissionDenied => 'Permiso de notificación denegado';

  @override
  String exportFailed(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get timePerHobby => 'Tiempo por Hobby';

  @override
  String get distribution => 'Distribución';

  @override
  String get dailyActivity => 'Actividad Diaria';

  @override
  String get bestDay => 'Mejor día';

  @override
  String get mostActiveHobby => 'Más activo';

  @override
  String minutesOnDate(Object minutes, Object date) {
    return '${minutes}m el $date';
  }

  @override
  String minutesTotal(Object minutes) {
    return '${minutes}m total';
  }

  @override
  String get theme => 'Tema';

  @override
  String get badges => 'Insignias';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get exportCsv => 'Exportar CSV';

  @override
  String get exportPdf => 'Exportar PDF';

  @override
  String get csvOrPdf => 'CSV o PDF';

  @override
  String get cloudSync => 'Sincronización en la Nube';

  @override
  String get syncNow => 'Sincronizar Ahora';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get syncComplete => '✓ Sincronización completa';

  @override
  String get autoSync => 'Sincronización automática';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInToSync => 'Inicia sesión para habilitar la sincronización';

  @override
  String get signInAndSync => 'Inicia sesión y sincroniza tus datos';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get user => 'Usuario';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get checkForUpdates => 'Buscar Actualizaciones';

  @override
  String get checking => 'Verificando...';

  @override
  String updateAvailable(String version) {
    return 'Actualización $version disponible';
  }

  @override
  String versionAvailable(String version) {
    return '$version disponible';
  }

  @override
  String badgeUnlocked(String emoji) {
    return '¡$emoji Insignia Desbloqueada!';
  }

  @override
  String youEarnedBadge(String title) {
    return '¡Ganaste \"$title\"!';
  }

  @override
  String get awesome => '¡Genial!';

  @override
  String get onboardingTitle1 => 'Rastrea Tus Hobbies';

  @override
  String get onboardingBody1 =>
      'Registra sesiones, establece metas y observa tu progreso crecer.';

  @override
  String get onboardingTitle2 => 'Gana Insignias y Rachas';

  @override
  String get onboardingBody2 =>
      'Mantente motivado con logros, rachas e insignias de hitos.';

  @override
  String get onboardingTitle3 => 'Sincroniza y Exporta';

  @override
  String get onboardingBody3 =>
      'Respalda en la nube y exporta tus datos como CSV o PDF.';

  @override
  String get language => 'Idioma';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mes';

  @override
  String get year => 'Año';

  @override
  String get catSports => 'Deportes';

  @override
  String get catMusic => 'Música';

  @override
  String get catArt => 'Arte';

  @override
  String get catReading => 'Lectura';

  @override
  String get catGaming => 'Videojuegos';

  @override
  String get catCooking => 'Cocina';

  @override
  String get catFitness => 'Ejercicio';

  @override
  String get catPhotography => 'Fotografía';

  @override
  String get catWriting => 'Escritura';

  @override
  String get catOther => 'Otro';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mié';

  @override
  String get dayThu => 'Jue';

  @override
  String get dayFri => 'Vie';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get everyDay => 'Todos los días';

  @override
  String get badge3DayStreak => 'Racha de 3 Días';

  @override
  String get badgeWeekWarrior => 'Guerrero Semanal';

  @override
  String get badgeMonthlyMaster => 'Maestro Mensual';

  @override
  String get badgeCenturyClub => 'Club del Siglo';

  @override
  String get badgeFirstStep => 'Primer Paso';

  @override
  String get badgeGettingSerious => 'En Serio';

  @override
  String get badgeDedicated => 'Dedicado';

  @override
  String get badgeCenturion => 'Centurión';

  @override
  String get badgeFirstHour => 'Primera Hora';

  @override
  String get badgeTimeInvestor => 'Inversor de Tiempo';

  @override
  String get badgeMasterOfTime => 'Maestro del Tiempo';

  @override
  String get badgeExplorer => 'Explorador';

  @override
  String get badgeAdventurer => 'Aventurero';

  @override
  String get badgeRenaissance => 'Renacimiento';

  @override
  String get streak => 'Racha';

  @override
  String get totalTime => 'Tiempo total';

  @override
  String get shareProgress => 'Compartir progreso';

  @override
  String get shareBadge => 'Compartir insignia';

  @override
  String shareHobbyText(Object hobbyName) {
    return '¡Mira mi progreso en $hobbyName en Hobby Tracker! 🎯';
  }

  @override
  String shareBadgeText(Object badgeTitle, Object emoji) {
    return '¡Acabo de ganar la insignia $badgeTitle en Hobby Tracker! $emoji';
  }
}
