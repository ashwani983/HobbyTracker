import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_edit_hobby_screen.dart';
import '../screens/add_goal_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/hobbies_list_screen.dart';
import '../screens/hobby_detail_screen.dart';
import '../screens/log_session_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/terms_screen.dart';
import '../screens/timer_screen.dart';
import '../widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/hobbies',
          builder: (context, state) => const HobbiesListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const AddEditHobbyScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => HobbyDetailScreen(
                hobbyId: state.pathParameters['id']!,
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => AddEditHobbyScreen(
                    hobbyId: state.pathParameters['id'],
                  ),
                ),
                GoRoute(
                  path: 'log',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => LogSessionScreen(
                    hobbyId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/timer',
          builder: (context, state) => const TimerScreen(),
        ),
        GoRoute(
          path: '/goals',
          builder: (context, state) => const GoalsScreen(),
          routes: [
            GoRoute(
              path: 'add',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const AddGoalScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsScreen(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsScreen(),
        ),
      ],
    ),
  ],
);
