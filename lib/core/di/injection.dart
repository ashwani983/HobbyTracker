import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/database.dart';
import '../../data/repositories/badge_repository_impl.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../data/repositories/hobby_repository_impl.dart';
import '../../data/repositories/reminder_repository_impl.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/repositories/badge_repository.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/usecases/archive_hobby.dart';
import '../../domain/usecases/check_badges.dart';
import '../../domain/usecases/create_goal.dart';
import '../../domain/usecases/create_hobby.dart';
import '../../domain/usecases/deactivate_goal.dart';
import '../../domain/usecases/get_active_goals.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../../domain/usecases/get_goal_progress.dart';
import '../../domain/usecases/get_recent_sessions.dart';
import '../../domain/usecases/get_sessions_by_hobby.dart';
import '../../domain/usecases/get_stats.dart';
import '../../domain/usecases/get_streak_count.dart';
import '../../domain/usecases/log_session.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../../domain/usecases/cancel_reminder.dart';
import '../../domain/usecases/update_reminder.dart';
import '../../domain/usecases/update_hobby.dart';
import '../../domain/usecases/attach_photos.dart';
import '../../domain/usecases/export_csv.dart';
import '../../domain/usecases/export_pdf.dart';
import '../../domain/usecases/sync_to_cloud.dart';
import '../../domain/usecases/sync_from_cloud.dart';
import '../../presentation/blocs/theme/theme_cubit.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/sync/sync_bloc.dart';
import '../../presentation/blocs/update/update_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repositories
  sl.registerLazySingleton<HobbyRepository>(() => HobbyRepositoryImpl(sl()));
  sl.registerLazySingleton<SessionRepository>(() => SessionRepositoryImpl(sl()));
  sl.registerLazySingleton<GoalRepository>(() => GoalRepositoryImpl(sl()));
  sl.registerLazySingleton<BadgeRepository>(() => BadgeRepositoryImpl(sl()));
  sl.registerLazySingleton<ReminderRepository>(() => ReminderRepositoryImpl(sl()));

  // Use cases
  sl.registerFactory(() => CreateHobby(sl()));
  sl.registerFactory(() => UpdateHobby(sl()));
  sl.registerFactory(() => ArchiveHobby(sl()));
  sl.registerFactory(() => GetActiveHobbies(sl()));
  sl.registerFactory(() => LogSession(sl()));
  sl.registerFactory(() => GetSessionsByHobby(sl()));
  sl.registerFactory(() => GetRecentSessions(sl()));
  sl.registerFactory(() => CreateGoal(sl()));
  sl.registerFactory(() => GetActiveGoals(sl()));
  sl.registerFactory(() => DeactivateGoal(sl()));
  sl.registerFactory(() => GetGoalProgress(sl()));
  sl.registerFactory(() => GetStats(sl<SessionRepository>(), sl<HobbyRepository>()));
  sl.registerFactory(() => GetStreakCount(sl()));
  sl.registerFactory(() => CheckBadges(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => ScheduleReminder(sl()));
  sl.registerFactory(() => CancelReminder(sl()));
  sl.registerFactory(() => UpdateReminder(sl()));
  sl.registerFactory(() => AttachPhotos());
  sl.registerFactory(() => ExportCsv(sl(), sl()));
  sl.registerFactory(() => ExportPdf(sl(), sl()));
  sl.registerFactory(() => SyncToCloud(sl(), sl(), sl()));
  sl.registerFactory(() => SyncFromCloud(sl(), sl(), sl()));

  // Cubits / BLoCs
  sl.registerFactory(() => ThemeCubit(sl<SharedPreferences>()));
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => SyncBloc(
        toCloud: sl(),
        fromCloud: sl(),
        prefs: sl(),
      ));
  sl.registerFactory(() => UpdateCubit(sl()));
}
