import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          _tile(context, Icons.repeat, 'Routines', '/routines'),
          _tile(context, Icons.flag, 'Goals', '/goals'),
          _tile(context, Icons.bar_chart, 'Stats', '/stats'),
          _tile(context, Icons.insights, 'Analytics', '/analytics'),
          _tile(context, Icons.emoji_events, 'Challenges', '/challenges'),
          const Divider(),
          _tile(context, Icons.settings, 'Settings', '/settings'),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, String path) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go(path),
    );
  }
}
