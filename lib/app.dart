import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

import 'core/di/injection.dart';
import 'domain/repositories/badge_repository.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/repositories/goal_repository.dart';
import 'domain/usecases/archive_hobby.dart';
import 'domain/usecases/check_badges.dart';
import 'domain/usecases/create_goal.dart';
import 'domain/usecases/create_hobby.dart';
import 'domain/usecases/deactivate_goal.dart';
import 'domain/usecases/get_active_goals.dart';
import 'domain/usecases/update_goal.dart';
import 'domain/usecases/get_active_hobbies.dart';
import 'domain/usecases/get_recent_sessions.dart';
import 'domain/usecases/get_stats.dart';
import 'domain/usecases/get_streak_count.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/badge/badge_bloc.dart';
import 'presentation/blocs/dashboard/dashboard_bloc.dart';
import 'presentation/blocs/goal/goal_bloc.dart';
import 'presentation/blocs/hobby_list/hobby_list_bloc.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/stats/stats_bloc.dart';
import 'presentation/blocs/sync/sync_bloc.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/theme/high_contrast_cubit.dart';
import 'presentation/blocs/update/update_cubit.dart';
import 'presentation/blocs/timer/timer_cubit.dart';
import 'presentation/blocs/routine/routine_bloc.dart';
import 'presentation/blocs/calendar/calendar_bloc.dart';
import 'presentation/blocs/analytics/analytics_bloc.dart';
import 'presentation/blocs/challenge/challenge_bloc.dart';
import 'presentation/blocs/partner/partner_bloc.dart';
import 'domain/repositories/challenge_repository.dart';
import 'domain/repositories/partner_repository.dart';
import 'domain/usecases/analytics_service.dart';
import 'domain/repositories/routine_repository.dart';
import 'domain/usecases/log_session.dart' as log_session_uc;
import 'presentation/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const _seed = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<HighContrastCubit>()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
        BlocProvider(
          create: (_) => HobbyListBloc(
            getActiveHobbies: sl<GetActiveHobbies>(),
            createHobby: sl<CreateHobby>(),
            archiveHobby: sl<ArchiveHobby>(),
          )..add(LoadHobbies()),
        ),
        BlocProvider(
          create: (_) => DashboardBloc(
            getActiveHobbies: sl<GetActiveHobbies>(),
            getRecentSessions: sl<GetRecentSessions>(),
            sessionRepository: sl<SessionRepository>(),
            getStreakCount: sl<GetStreakCount>(),
            badgeRepository: sl<BadgeRepository>(),
          )..add(LoadDashboard()),
        ),
        BlocProvider(
          create: (_) => GoalBloc(
            getActiveGoals: sl<GetActiveGoals>(),
            createGoal: sl<CreateGoal>(),
            updateGoal: sl<UpdateGoal>(),
            deactivateGoal: sl<DeactivateGoal>(),
          )..add(LoadGoals()),
        ),
        BlocProvider(
          create: (_) => StatsBloc(getStats: sl<GetStats>())..add(LoadStats()),
        ),
        BlocProvider(create: (_) => TimerCubit(sl<SharedPreferences>())),
        BlocProvider(
          create: (_) => BadgeBloc(
            badgeRepository: sl<BadgeRepository>(),
            checkBadges: sl<CheckBadges>(),
          )..add(LoadBadges()),
        ),
        BlocProvider(create: (_) => sl<AuthBloc>()..add(CheckAuth())),
        BlocProvider(create: (_) => sl<SyncBloc>()..add(LoadSyncPref())),
        BlocProvider(create: (_) => sl<UpdateCubit>()..check()),
        BlocProvider(create: (_) => RoutineBloc(sl<RoutineRepository>(), sl<log_session_uc.LogSession>())..add(LoadRoutines())),
        BlocProvider(create: (_) => CalendarBloc(sl<SessionRepository>())),
        BlocProvider(create: (_) => AnalyticsBloc(sl<AnalyticsService>())),
        BlocProvider(create: (_) => ChallengeBloc(sl<ChallengeRepository>(), sl<SharedPreferences>())..add(LoadChallenges())),
        BlocProvider(create: (_) => PartnerBloc(
          repo: sl<PartnerRepository>(),
          sessionRepo: sl<SessionRepository>(),
          goalRepo: sl<GoalRepository>(),
        )),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, locale) {
              return BlocBuilder<HighContrastCubit, bool>(
                builder: (context, highContrast) {
                  return MaterialApp.router(
                    title: 'Hobby Tracker',
                    themeMode: themeMode,
                    locale: locale,
                    localizationsDelegates: AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    theme: ThemeData(
                      colorScheme: highContrast
                          ? const ColorScheme.light(
                              primary: Color(0xFF000000),
                              onPrimary: Color(0xFFFFFFFF),
                              surface: Color(0xFFFFFFFF),
                              onSurface: Color(0xFF000000),
                            )
                          : ColorScheme.fromSeed(seedColor: _seed),
                      useMaterial3: true,
                    ),
                    darkTheme: ThemeData(
                      colorScheme: highContrast
                          ? const ColorScheme.dark(
                              primary: Color(0xFFFFFF00),
                              onPrimary: Color(0xFF000000),
                              surface: Color(0xFF000000),
                              onSurface: Color(0xFFFFFFFF),
                            )
                          : ColorScheme.fromSeed(
                              seedColor: _seed,
                              brightness: Brightness.dark,
                            ),
                      useMaterial3: true,
                    ),
                    routerConfig: appRouter,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
