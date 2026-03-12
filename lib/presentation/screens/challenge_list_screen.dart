import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/challenge/challenge_bloc.dart';

class ChallengeListScreen extends StatefulWidget {
  const ChallengeListScreen({super.key});

  @override
  State<ChallengeListScreen> createState() => _ChallengeListScreenState();
}

class _ChallengeListScreenState extends State<ChallengeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChallengeBloc>().add(LoadChallenges());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/more')),
        title: const Text('Challenges'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'join',
            onPressed: () => _showJoinDialog(context),
            child: const Icon(Icons.link),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'create',
            onPressed: () => _showCreateDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<ChallengeBloc, ChallengeState>(
        listenWhen: (_, c) => c is ChallengeError,
        listener: (context, state) {
          if (state is ChallengeError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.read<ChallengeBloc>().add(LoadChallenges());
          }
        },
        buildWhen: (_, c) => c is ChallengesLoaded || c is ChallengeLoading || c is ChallengeInitial || c is ChallengeError,
        builder: (context, state) {
          if (state is ChallengeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChallengesLoaded) {
            if (state.challenges.isEmpty) {
              return const Center(child: Text('No challenges yet'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChallengeBloc>().add(LoadChallenges());
                await Future.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
              itemCount: state.challenges.length,
              itemBuilder: (context, i) {
                final c = state.challenges[i];
                final now = DateTime.now();
                final status = now.isBefore(c.startDate)
                    ? 'Starts ${c.startDate.month}/${c.startDate.day}'
                    : now.isAfter(c.endDate)
                        ? 'Ended'
                        : 'Active';
                return ListTile(
                  leading: Text(
                    AppConstants.emojiForCategory(c.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(c.name),
                  subtitle: Text('${c.category} · $status'),
                  trailing: IconButton(
                    icon: const Icon(Icons.share, size: 18),
                    tooltip: 'Share invite',
                    onPressed: () => Share.share(
                      'Join my challenge "${c.name}" on Hobby Tracker!\n\n'
                      'Use invite code: ${c.inviteCode}\n\n'
                      'Or tap: hobbytracker://challenge/${c.inviteCode}',
                    ),
                  ),
                  onTap: () => context.push('/challenges/${c.id}'),
                );
              },
            ),
            );
          }
          return const Center(child: Text('Enable cloud sync to participate'));
        },
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join Challenge'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Invite code'),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                context.read<ChallengeBloc>().add(JoinByCode(code));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) async {
    final hobbies = await sl<GetActiveHobbies>()();
    final categories = hobbies.map((h) => h.category).toSet().toList()..sort();
    if (categories.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add a hobby first')));
      }
      return;
    }

    final nameC = TextEditingController();
    final minC = TextEditingController();
    final limitC = TextEditingController(text: '10');
    var selectedCat = categories.first;
    var start = DateTime.now();
    var end = DateTime.now().add(const Duration(days: 7));

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Create Challenge'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameC,
                    decoration:
                        const InputDecoration(labelText: 'Challenge name')),
                DropdownButtonFormField<String>(
                  initialValue: selectedCat,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setSt(() => selectedCat = v);
                  },
                ),
                TextField(
                    controller: minC,
                    decoration:
                        const InputDecoration(labelText: 'Target minutes'),
                    keyboardType: TextInputType.number),
                TextField(
                    controller: limitC,
                    decoration: const InputDecoration(
                        labelText: 'Max participants (2-50)'),
                    keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final d = await showDatePicker(
                              context: ctx,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              initialDate: start);
                          if (d != null) setSt(() => start = d);
                        },
                        child: Text('Start: ${start.month}/${start.day}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final d = await showDatePicker(
                              context: ctx,
                              firstDate: start,
                              lastDate:
                                  start.add(const Duration(days: 365)),
                              initialDate: end);
                          if (d != null) setSt(() => end = d);
                        },
                        child: Text('End: ${end.month}/${end.day}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final name = nameC.text.trim();
                final mins = int.tryParse(minC.text.trim()) ?? 0;
                final limit =
                    (int.tryParse(limitC.text.trim()) ?? 10).clamp(2, 50);
                if (name.isEmpty || mins <= 0) return;
                context.read<ChallengeBloc>().add(CreateChallenge(
                      name: name,
                      category: selectedCat,
                      targetMinutes: mins,
                      startDate: start,
                      endDate: end,
                      participantLimit: limit,
                    ));
                Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
