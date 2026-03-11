import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/notification_service.dart';
import '../blocs/badge/badge_bloc.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';
import '../blocs/stats/stats_bloc.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hobbyId = NotificationService.consumePendingHobbyId();
      if (hobbyId != null && mounted) {
        context.go('/timer?hobbyId=$hobbyId');
      }
    });
  }

  static const _tabs = [
    ('/', Icons.dashboard, 'Dashboard'),
    ('/hobbies', Icons.interests, 'Hobbies'),
    ('/timer', Icons.timer, 'Timer'),
    ('/goals', Icons.flag, 'Goals'),
    ('/stats', Icons.bar_chart, 'Stats'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabs[i].$1) &&
          (_tabs[i].$1 == '/' ? location == '/' : true)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    return BlocListener<BadgeBloc, BadgeState>(
      listener: (context, state) {
        if (state is NewBadgeUnlocked) {
          for (final badge in state.newBadges) {
            showDialog(
              context: context,
              builder: (dialogCtx) => AlertDialog(
                title: Text('${badge.emoji} Badge Unlocked!'),
                content: Text('You earned "${badge.title}"!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: const Text('Awesome!'),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) {
            context.go(_tabs[i].$1);
            if (i == 0) {
              context.read<DashboardBloc>().add(LoadDashboard());
              context.read<HobbyListBloc>().add(LoadHobbies());
            } else if (i == 1) {
              context.read<HobbyListBloc>().add(LoadHobbies());
            } else if (i == 4) {
              context.read<StatsBloc>().add(LoadStats());
            }
          },
          destinations: _tabs
              .map((t) =>
                  NavigationDestination(icon: Icon(t.$2), label: t.$3))
              .toList(),
        ),
      ),
    );
  }
}
