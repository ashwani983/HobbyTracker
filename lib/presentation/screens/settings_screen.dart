import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/locale/locale_cubit.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/high_contrast_cubit.dart';
import '../blocs/update/update_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _localeOptions = [
    (null, 'System'),
    (Locale('en'), 'English'),
    (Locale('es'), 'Español'),
    (Locale('fr'), 'Français'),
    (Locale('de'), 'Deutsch'),
    (Locale('ja'), '日本語'),
    (Locale('hi'), 'हिन्दी'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/')),
        title: Text(l.settings),
      ),
      body: ListView(
        children: [
          // Theme
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (ctx, mode) => ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l.theme),
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

          // High Contrast
          BlocBuilder<HighContrastCubit, bool>(
            builder: (ctx, hc) => SwitchListTile(
              secondary: const Icon(Icons.contrast),
              title: const Text('High Contrast'),
              value: hc,
              onChanged: (_) => ctx.read<HighContrastCubit>().toggle(),
            ),
          ),

          // Language
          BlocBuilder<LocaleCubit, Locale?>(
            builder: (ctx, locale) => ListTile(
              leading: const Icon(Icons.language),
              title: Text(l.language),
              trailing: DropdownButton<Locale?>(
                value: locale,
                underline: const SizedBox.shrink(),
                items: _localeOptions
                    .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                    .toList(),
                onChanged: (v) => ctx.read<LocaleCubit>().setLocale(v),
              ),
            ),
          ),
          const Divider(),

          // Cloud Sync
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: Text(l.cloudSync),
            subtitle: Text(l.signInAndSync),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/sync'),
          ),

          // Export
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: Text(l.exportData),
            subtitle: Text(l.csvOrPdf),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/export'),
          ),

          // Badges
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: Text(l.badges),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/badges'),
          ),
          const Divider(),

          // Terms
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsAndConditions),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/terms'),
          ),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.about),
            onTap: () async {
              final info = await PackageInfo.fromPlatform();
              if (!context.mounted) return;
              showAboutDialog(
                context: context,
                applicationName: l.appTitle,
                applicationVersion: 'v${info.version} (${info.buildNumber})',
                applicationIcon: const Icon(Icons.sports_esports, size: 48),
              );
            },
          ),

          // Check for updates
          BlocBuilder<UpdateCubit, UpdateState>(
            builder: (ctx, state) => ListTile(
              leading: const Icon(Icons.system_update),
              title: Text(l.checkForUpdates),
              subtitle: state is UpdateAvailable
                  ? Text(l.versionAvailable(state.release.tagName))
                  : state is UpdateChecking
                      ? Text(l.checking)
                      : null,
              trailing: state is UpdateAvailable
                  ? TextButton(
                      onPressed: () async {
                        final uri = Uri.parse(state.release.htmlUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Text(l.update),
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
