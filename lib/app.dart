import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'domain/repositories/session_repository.dart';
import 'domain/usecases/archive_hobby.dart';
import 'domain/usecases/create_goal.dart';
import 'domain/usecases/create_hobby.dart';
import 'domain/usecases/deactivate_goal.dart';
import 'domain/usecases/get_active_goals.dart';
import 'domain/usecases/get_active_hobbies.dart';
import 'domain/usecases/get_recent_sessions.dart';
import 'domain/usecases/get_stats.dart';
import 'presentation/blocs/dashboard/dashboard_bloc.dart';
import 'presentation/blocs/goal/goal_bloc.dart';
import 'presentation/blocs/hobby_list/hobby_list_bloc.dart';
import 'presentation/blocs/stats/stats_bloc.dart';
import 'presentation/blocs/timer/timer_cubit.dart';
import 'presentation/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
          )..add(LoadDashboard()),
        ),
        BlocProvider(
          create: (_) => GoalBloc(
            getActiveGoals: sl<GetActiveGoals>(),
            createGoal: sl<CreateGoal>(),
            deactivateGoal: sl<DeactivateGoal>(),
          )..add(LoadGoals()),
        ),
        BlocProvider(
          create: (_) => StatsBloc(getStats: sl<GetStats>())..add(LoadStats()),
        ),
        BlocProvider(create: (_) => TimerCubit()),
      ],
      child: MaterialApp.router(
        title: 'Hobby Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
