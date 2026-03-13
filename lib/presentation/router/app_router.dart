import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/goal.dart';
import '../screens/add_edit_hobby_screen.dart';
import '../screens/add_goal_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/export_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/hobbies_list_screen.dart';
import '../screens/hobby_detail_screen.dart';
import '../screens/log_session_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/stats_screen.dart';
import '../screens/sync_settings_screen.dart';
import '../screens/terms_screen.dart';
import '../screens/timer_screen.dart';
import '../screens/badges_screen.dart';
import '../screens/routine_list_screen.dart';
import '../screens/routine_runner_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/more_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/challenge_list_screen.dart';
import '../screens/challenge_detail_screen.dart';
import '../screens/partner_screen.dart';
import '../widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final done = sl<SharedPreferences>().getBool('onboarding_done') ?? false;
    final onboarding = state.matchedLocation == '/onboarding';
    if (!done && !onboarding) return '/onboarding';
    if (done && onboarding) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/routines/:id/run',
      builder: (context, state) => RoutineRunnerScreen(
        routineId: state.pathParameters['id']!,
      ),
    ),
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
          builder: (context, state) {
            final hobbyId = state.uri.queryParameters['hobbyId'];
            return TimerScreen(initialHobbyId: hobbyId);
          },
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
            GoRoute(
              path: 'edit',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => AddGoalScreen(
                existingGoal: state.extra as Goal?,
              ),
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
        GoRoute(
          path: '/badges',
          builder: (context, state) => BadgesScreen(),
        ),
        GoRoute(
          path: '/export',
          builder: (context, state) => const ExportScreen(),
        ),
        GoRoute(
          path: '/sync',
          builder: (context, state) => const SyncSettingsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/routines',
          builder: (context, state) => const RoutineListScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/challenges',
          builder: (context, state) => const ChallengeListScreen(),
        ),
        GoRoute(
          path: '/challenges/:id',
          builder: (context, state) => ChallengeDetailScreen(
            challengeId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/partners',
          builder: (context, state) => const PartnerScreen(),
        ),
      ],
    ),
  ],
);
