import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/badge.dart' as app;
import '../../core/l10n_helpers.dart';
import '../../domain/entities/share_progress_card.dart';
import '../../domain/usecases/share_card_service.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/badge/badge_bloc.dart';
import '../widgets/share_card_widget.dart';

class BadgesScreen extends StatelessWidget {
  BadgesScreen({super.key});

  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/settings')),
        title: Text(l.badges),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => ShareCardService.shareWidget(_repaintKey, 'My Badges — Hobby Tracker'),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _repaintKey,
        child: BlocBuilder<BadgeBloc, BadgeState>(
        builder: (context, state) {
          if (state is BadgeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BadgeError) {
            return Center(child: Text(state.message));
          }
          final badges = state is BadgeLoaded
              ? state.badges
              : state is NewBadgeUnlocked
                  ? state.allBadges
                  : app.Badge.all;
          final unlocked = badges.where((b) => b.isUnlocked).length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l.unlockedCount(unlocked, badges.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, i) => _BadgeTile(badge: badges[i]),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final app.Badge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final unlocked = badge.isUnlocked;
    final l = AppLocalizations.of(context)!;
    final title = localizedBadgeTitles(l)[badge.id] ?? badge.title;
    return Card(
      color: unlocked
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetail(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              badge.emoji,
              style: TextStyle(
                fontSize: 32,
                color: unlocked ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: unlocked ? null : Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = localizedBadgeTitles(l)[badge.id] ?? badge.title;
    final cardKey = GlobalKey();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${badge.emoji} $title'),
        content: badge.isUnlocked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.unlockedOn('${badge.unlockedAt!.month}/${badge.unlockedAt!.day}/${badge.unlockedAt!.year}')),
                  const SizedBox(height: 16),
                  RepaintBoundary(
                    key: cardKey,
                    child: ShareCardWidget(
                      card: ShareProgressCard(
                        hobbyName: '',
                        category: '',
                        totalSessions: 0,
                        totalMinutes: 0,
                        streakDays: 0,
                        badgeEmoji: badge.emoji,
                        badgeTitle: title,
                      ),
                    ),
                  ),
                ],
              )
            : Text(l.reachToUnlock(badge.threshold, badge.type.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.ok),
          ),
          if (badge.isUnlocked)
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: Text(l.shareBadge),
              onPressed: () {
                Navigator.pop(dialogContext);
                ShareCardService.shareWidget(
                  cardKey,
                  l.shareBadgeText(title, badge.emoji),
                );
              },
            ),
        ],
      ),
    );
  }
}
