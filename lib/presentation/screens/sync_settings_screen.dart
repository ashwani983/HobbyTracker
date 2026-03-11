import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/sync/sync_bloc.dart';

class SyncSettingsScreen extends StatelessWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/settings')),
        title: Text(l.cloudSync),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (ctx, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(ctx)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (ctx, authState) {
                if (authState is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (authState is Authenticated) {
                  return _SignedInSection(user: authState.user);
                }
                return _SignInSection();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SignInSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.signInToSync),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.account_circle),
          label: Text(l.signInWithGoogle),
          onPressed: () =>
              context.read<AuthBloc>().add(SignInWithGoogle()),
        ),
      ],
    );
  }
}

class _SignedInSection extends StatelessWidget {
  final dynamic user;
  const _SignedInSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(user.displayName ?? user.email ?? l.user),
          subtitle: Text(user.email ?? ''),
        ),
        const Divider(),
        BlocBuilder<SyncBloc, SyncState>(
          builder: (ctx, syncState) {
            final enabled = syncState is SyncIdle
                ? syncState.enabled
                : syncState is SyncDone
                    ? syncState.enabled
                    : false;
            return Column(
              children: [
                SwitchListTile(
                  title: Text(l.autoSync),
                  value: enabled,
                  onChanged: (v) =>
                      ctx.read<SyncBloc>().add(ToggleSync(v)),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: syncState is Syncing
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: Text(syncState is Syncing ? l.syncing : l.syncNow),
                  onPressed: syncState is Syncing
                      ? null
                      : () => ctx
                          .read<SyncBloc>()
                          .add(SyncNow(user.uid as String)),
                ),
                if (syncState is SyncDone)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l.syncComplete,
                        style: const TextStyle(color: Colors.green)),
                  ),
                if (syncState is SyncError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(syncState.message,
                        style: const TextStyle(color: Colors.red)),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => context.read<AuthBloc>().add(SignOut()),
          child: Text(l.signOut),
        ),
      ],
    );
  }
}
