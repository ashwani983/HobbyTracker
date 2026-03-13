import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/partner/partner_bloc.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PartnerBloc>().add(LoadPartners());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/more'),
        ),
        title: const Text('Partners'),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'accept',
            onPressed: () => _showAcceptDialog(context),
            child: const Icon(Icons.link),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'invite',
            onPressed: () =>
                context.read<PartnerBloc>().add(SendPartnerRequest()),
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: BlocConsumer<PartnerBloc, PartnerState>(
        listenWhen: (_, c) => c is PartnerError || (c is PartnersLoaded && c.inviteCode != null),
        listener: (context, state) {
          if (state is PartnerError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            context.read<PartnerBloc>().add(LoadPartners());
          }
          if (state is PartnersLoaded && state.inviteCode != null) {
            _showInviteCodeDialog(context, state.inviteCode!);
          }
        },
        buildWhen: (_, c) =>
            c is PartnersLoaded || c is PartnerLoading || c is PartnerInitial,
        builder: (context, state) {
          if (state is PartnerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PartnersLoaded) {
            if (state.partners.isEmpty) {
              return const Center(
                child: Text('No partners yet.\nTap + to invite someone!',
                    textAlign: TextAlign.center),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PartnerBloc>().add(LoadPartners());
                await Future.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
                itemCount: state.partners.length,
                itemBuilder: (context, i) {
                  final p = state.partners[i];
                  final s = i < state.stats.length ? state.stats[i] : null;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, size: 32),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(p.partnerDisplayName,
                                    style: Theme.of(context).textTheme.titleMedium),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => _confirmRemove(context, p.id),
                              ),
                            ],
                          ),
                          if (s != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statChip('🔥 Streak', '${s.currentStreak}d'),
                                _statChip('⏱ Weekly', '${s.weeklyMinutes}m'),
                                _statChip('🎯 Goals', '${s.goalCompletionPercent}%'),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text('Enable cloud sync to use partners'));
        },
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void _showAcceptDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Accept Invite'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Invite Code'),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PartnerBloc>().add(AcceptPartnerRequest(controller.text.trim()));
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showInviteCodeDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your Invite Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
            const SizedBox(height: 8),
            const Text('Valid for 48 hours', style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            onPressed: () {
              Navigator.pop(ctx);
              Share.share('Be my accountability partner on Hobby Tracker!\n\nUse code: $code');
            },
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, String partnerId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Partner?'),
        content: const Text('This will remove the partnership for both of you.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PartnerBloc>().add(RemovePartner(partnerId));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
