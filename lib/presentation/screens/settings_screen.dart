import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/theme/theme_cubit.dart';
import '../blocs/update/update_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Theme
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (ctx, mode) => ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              trailing: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.settings_brightness)),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
                ],
                selected: {mode},
                onSelectionChanged: (s) => ctx.read<ThemeCubit>().setTheme(s.first),
              ),
            ),
          ),
          const Divider(),

          // Cloud Sync
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text('Cloud Sync'),
            subtitle: const Text('Sign in & sync your data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/sync'),
          ),

          // Export
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Export Data'),
            subtitle: const Text('CSV or PDF'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/export'),
          ),

          // Badges
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Badges'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/badges'),
          ),
          const Divider(),

          // Terms
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/terms'),
          ),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () async {
              final info = await PackageInfo.fromPlatform();
              if (!context.mounted) return;
              showAboutDialog(
                context: context,
                applicationName: 'Hobby Tracker',
                applicationVersion: 'v${info.version} (${info.buildNumber})',
                applicationIcon: const Icon(Icons.sports_esports, size: 48),
              );
            },
          ),

          // Check for updates
          BlocBuilder<UpdateCubit, UpdateState>(
            builder: (ctx, state) => ListTile(
              leading: const Icon(Icons.system_update),
              title: const Text('Check for Updates'),
              subtitle: state is UpdateAvailable
                  ? Text('${state.release.tagName} available')
                  : state is UpdateChecking
                      ? const Text('Checking...')
                      : const Text('You\'re up to date'),
              trailing: state is UpdateAvailable
                  ? TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(state.release.htmlUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text('Update'),
                    )
                  : null,
              onTap: () => ctx.read<UpdateCubit>().check(force: true),
            ),
          ),
        ],
      ),
    );
  }
}
