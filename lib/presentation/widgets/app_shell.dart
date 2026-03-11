import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
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

  static const _tabPaths = ['/', '/hobbies', '/timer', '/goals', '/stats'];
  static const _tabIcons = [
    Icons.dashboard,
    Icons.interests,
    Icons.timer,
    Icons.flag,
    Icons.bar_chart,
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _tabPaths.length - 1; i >= 0; i--) {
      if (location.startsWith(_tabPaths[i]) &&
          (_tabPaths[i] == '/' ? location == '/' : true)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);
    final l = AppLocalizations.of(context)!;
    final tabLabels = [l.dashboard, l.hobbies, l.timer, l.goals, l.stats];

    return BlocListener<BadgeBloc, BadgeState>(
      listener: (context, state) {
        if (state is NewBadgeUnlocked) {
          for (final badge in state.newBadges) {
            showDialog(
              context: context,
              builder: (dialogCtx) => AlertDialog(
                title: Text(l.badgeUnlocked(badge.emoji)),
                content: Text(l.youEarnedBadge(badge.title)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    child: Text(l.awesome),
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
            context.go(_tabPaths[i]);
            if (i == 0) {
              context.read<DashboardBloc>().add(LoadDashboard());
              context.read<HobbyListBloc>().add(LoadHobbies());
            } else if (i == 1) {
              context.read<HobbyListBloc>().add(LoadHobbies());
            } else if (i == 4) {
              context.read<StatsBloc>().add(LoadStats());
            }
          },
          destinations: List.generate(
            _tabPaths.length,
            (i) => NavigationDestination(
              icon: Icon(_tabIcons[i]),
              label: tabLabels[i],
            ),
          ),
        ),
      ),
    );
  }
}
