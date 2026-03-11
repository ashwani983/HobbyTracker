import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/sync/sync_bloc.dart';

class SyncSettingsScreen extends StatelessWidget {
  const SyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cloud Sync')),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Sign in to enable cloud sync'),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.account_circle),
          label: const Text('Sign in with Google'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(user.displayName ?? user.email ?? 'User'),
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
                  title: const Text('Auto sync'),
                  value: enabled,
                  onChanged: (v) =>
                      ctx.read<SyncBloc>().add(ToggleSync(v)),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: syncState is Syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync),
                  label: Text(syncState is Syncing ? 'Syncing...' : 'Sync Now'),
                  onPressed: syncState is Syncing
                      ? null
                      : () => ctx
                          .read<SyncBloc>()
                          .add(SyncNow(user.uid as String)),
                ),
                if (syncState is SyncDone)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('✓ Sync complete',
                        style: TextStyle(color: Colors.green)),
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
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
