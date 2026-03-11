import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/di/injection.dart';
import '../../domain/usecases/export_csv.dart';
import '../../domain/usecases/export_pdf.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DateTimeRange? _range;
  bool _busy = false;

  Future<void> _export(bool isPdf) async {
    setState(() => _busy = true);
    try {
      final file = isPdf
          ? await sl<ExportPdf>()(from: _range?.start, to: _range?.end)
          : await sl<ExportCsv>()(from: _range?.start, to: _range?.end);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/settings')),
        title: const Text('Export Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text(_range == null
                  ? 'All time'
                  : '${_fmt(_range!.start)} — ${_fmt(_range!.end)}'),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _range,
                );
                if (picked != null) setState(() => _range = picked);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.table_chart),
              label: const Text('Export CSV'),
              onPressed: _busy ? null : () => _export(false),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
              onPressed: _busy ? null : () => _export(true),
            ),
            if (_busy) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.month}/${d.day}/${d.year}';
}
