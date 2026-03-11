import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';
import '../blocs/stats/stats_bloc.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

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
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          context.go(_tabs[i].$1);
          // Refresh data when switching tabs
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
            .map((t) => NavigationDestination(icon: Icon(t.$2), label: t.$3))
            .toList(),
      ),
    );
  }
}
