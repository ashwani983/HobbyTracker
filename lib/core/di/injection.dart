import 'package:get_it/get_it.dart';

import '../../data/datasources/database.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../data/repositories/hobby_repository_impl.dart';
import '../../data/repositories/session_repository_impl.dart';
import '../../domain/repositories/goal_repository.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/usecases/archive_hobby.dart';
import '../../domain/usecases/create_goal.dart';
import '../../domain/usecases/create_hobby.dart';
import '../../domain/usecases/deactivate_goal.dart';
import '../../domain/usecases/get_active_goals.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../../domain/usecases/get_goal_progress.dart';
import '../../domain/usecases/get_recent_sessions.dart';
import '../../domain/usecases/get_sessions_by_hobby.dart';
import '../../domain/usecases/get_stats.dart';
import '../../domain/usecases/log_session.dart';
import '../../domain/usecases/update_hobby.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Repositories
  sl.registerLazySingleton<HobbyRepository>(
    () => HobbyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GoalRepository>(
    () => GoalRepositoryImpl(sl()),
  );

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
}
