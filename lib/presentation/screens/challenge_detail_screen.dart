import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/challenge.dart';
import '../blocs/challenge/challenge_bloc.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId;
  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChallengeBloc>().add(WatchLeaderboard(widget.challengeId));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ChallengeBloc>().add(LoadChallenges());
              context.go('/challenges');
            }),
        title: const Text('Challenge'),
        actions: [
          if (uid != null)
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Leave challenge',
              onPressed: () {
                context
                    .read<ChallengeBloc>()
                    .add(LeaveChallenge(widget.challengeId));
                context.go('/challenges');
              },
            ),
        ],
      ),
      body: BlocBuilder<ChallengeBloc, ChallengeState>(
        builder: (context, state) {
          if (state is LeaderboardLoaded) {
            final isCreator = uid == state.challenge.creatorUid;
            return _buildContent(state.challenge, state.entries, uid, isCreator);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(
      Challenge c, List<LeaderboardEntry> entries, String? uid, bool isCreator) {
    final now = DateTime.now();
    final ended = now.isAfter(c.endDate);
    final daysLeft = ended ? 0 : c.endDate.difference(now).inDays;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: Text(c.name, style: Theme.of(context).textTheme.headlineSmall)),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => Share.share(
                'Join my challenge "${c.name}" on Hobby Tracker!\n\n'
                'Category: ${c.category}\n'
                'Target: ${c.targetMinutes} min\n\n'
                'Use invite code: ${c.inviteCode}\n\n'
                'Or tap: hobbytracker://challenge/${c.inviteCode}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('${c.category} · Target: ${c.targetMinutes} min'),
        Text(ended
            ? 'Challenge ended'
            : '$daysLeft days remaining'),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Invite code: '),
            SelectableText(c.inviteCode,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: c.inviteCode));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied')));
              },
            ),
          ],
        ),
        const Divider(height: 24),
        Text('Leaderboard',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Text('No participants yet')
        else
          ...entries.asMap().entries.map((e) {
            final rank = e.key + 1;
            final entry = e.value;
            final isMe = entry.uid == uid;
            final medal = rank == 1
                ? '🥇'
                : rank == 2
                    ? '🥈'
                    : rank == 3
                        ? '🥉'
                        : '#$rank';
            return ListTile(
              leading: Text(medal, style: const TextStyle(fontSize: 20)),
              title: Text(
                entry.displayName,
                style: isMe
                    ? const TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              trailing: Text('${entry.totalMinutes} min'),
            );
          }),
        if (isCreator) ...[
          const Divider(height: 32),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.delete),
            label: const Text('Delete Challenge'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Challenge?'),
                  content: const Text('This will remove the challenge for all participants.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(ctx);
                        final bloc = context.read<ChallengeBloc>();
                        final router = GoRouter.of(context);
                        bloc.add(DeleteChallenge(c.id));
                        Future.delayed(const Duration(milliseconds: 500), () {
                          router.go('/challenges');
                        });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
