import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/services/wearable_service.dart';

class WearableScreen extends StatefulWidget {
  const WearableScreen({super.key});

  @override
  State<WearableScreen> createState() => _WearableScreenState();
}

class _WearableScreenState extends State<WearableScreen> {
  final _service = WearableService.instance;
  bool _checking = true;
  bool _connected = false;
  String _nodeName = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() { _checking = true; _error = null; });
    try {
      final nodes = await _service.getConnectedNodes();
      setState(() {
        _connected = nodes.isNotEmpty;
        _nodeName = nodes.isNotEmpty ? (nodes.first['name'] as String? ?? '') : '';
        _checking = false;
      });
    } on MissingPluginException {
      setState(() { _connected = false; _checking = false; _error = 'Wearable API not available'; });
    } catch (e) {
      setState(() { _connected = false; _checking = false; _error = e.toString(); });
    }
  }

  Future<void> _syncNow() async {
    try {
      await _service.syncHobbies([]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync sent to watch')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wearable')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(
                  _connected ? Icons.watch : Icons.watch_off,
                  size: 36,
                  color: _connected ? Colors.green : Colors.grey,
                ),
                title: Text(_connected ? 'Watch Connected' : 'No Watch Connected'),
                subtitle: Text(_connected
                    ? _nodeName
                    : _error ?? 'Pair a Wear OS watch to get started'),
                trailing: _checking
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _checkConnection,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Features', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _featureRow(Icons.list, 'Hobby list syncs to watch automatically'),
            _featureRow(Icons.timer, 'Start/stop timers from your watch'),
            _featureRow(Icons.trending_up, 'View streak & daily stats on watch face'),
            _featureRow(Icons.offline_bolt, 'Offline mode — syncs when reconnected'),
            const Spacer(),
            if (_connected)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                  onPressed: _syncNow,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
