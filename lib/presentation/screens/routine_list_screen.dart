import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/entities/routine.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/routine/routine_bloc.dart';

class RoutineListScreen extends StatefulWidget {
  const RoutineListScreen({super.key});
  @override
  State<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends State<RoutineListScreen> {
  List<Hobby> _hobbies = [];

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    final h = await sl<GetActiveHobbies>()();
    if (mounted) setState(() => _hobbies = h);
  }

  String _hobbyName(String id) =>
      _hobbies.where((h) => h.id == id).firstOrNull?.name ?? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/more')),
        title: const Text('Routines'),
      ),
      body: BlocBuilder<RoutineBloc, RoutineState>(
        builder: (context, state) {
          if (state is RoutinesLoaded) {
            if (state.routines.isEmpty) {
              return const Center(child: Text('No routines yet'));
            }
            return ListView.builder(
              itemCount: state.routines.length,
              itemBuilder: (ctx, i) {
                final r = state.routines[i];
                return ListTile(
                  title: Text(r.name),
                  subtitle: Text('${r.steps.length} hobbies · ${r.steps.fold<int>(0, (s, e) => s + e.targetMinutes)} min'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _showEditDialog(context, r),
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => context.go('/routines/${r.id}/run'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => context.read<RoutineBloc>().add(DeleteRoutineEvent(r.id)),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    if (_hobbies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add hobbies first')),
      );
      return;
    }
    final nameCtrl = TextEditingController();
    final steps = <RoutineStep>[];
    _showRoutineDialog(context, nameCtrl, steps, 'New Routine', 'Create', (name, s) {
      context.read<RoutineBloc>().add(CreateRoutineEvent(name: name, steps: s));
    });
  }

  void _showEditDialog(BuildContext context, Routine routine) {
    final nameCtrl = TextEditingController(text: routine.name);
    final steps = List<RoutineStep>.from(routine.steps);
    _showRoutineDialog(context, nameCtrl, steps, 'Edit Routine', 'Save', (name, s) {
      context.read<RoutineBloc>().add(UpdateRoutineEvent(id: routine.id, name: name, steps: s));
    });
  }

  void _showRoutineDialog(BuildContext context, TextEditingController nameCtrl,
      List<RoutineStep> steps, String title, String actionLabel, void Function(String, List<RoutineStep>) onSave) {

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Routine name'),
                ),
                const SizedBox(height: 12),
                ...steps.asMap().entries.map((e) => ListTile(
                      dense: true,
                      title: Text(_hobbyName(e.value.hobbyId)),
                      subtitle: Text('${e.value.targetMinutes} min'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        onPressed: () => setDialogState(() => steps.removeAt(e.key)),
                      ),
                    )),
                TextButton.icon(
                  onPressed: () => _addStep(ctx, steps, setDialogState),
                  icon: const Icon(Icons.add),
                  label: const Text('Add hobby'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: nameCtrl.text.trim().isEmpty || steps.length < 2
                  ? null
                  : () {
                      onSave(nameCtrl.text.trim(), steps);
                      Navigator.pop(ctx);
                    },
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }

  void _addStep(BuildContext ctx, List<RoutineStep> steps, StateSetter setDialogState) {
    String? selectedId = _hobbies.first.id;
    int mins = 10;
    showDialog(
      context: ctx,
      builder: (innerCtx) => StatefulBuilder(
        builder: (innerCtx, setInner) => AlertDialog(
          title: const Text('Add Hobby Step'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedId,
                items: _hobbies.map((h) => DropdownMenuItem(value: h.id, child: Text(h.name))).toList(),
                onChanged: (v) => setInner(() => selectedId = v),
                decoration: const InputDecoration(labelText: 'Hobby'),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: mins > 1 ? () => setInner(() => mins--) : null, icon: const Icon(Icons.remove)),
                  Text('$mins min'),
                  IconButton(onPressed: () => setInner(() => mins++), icon: const Icon(Icons.add)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(innerCtx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                setDialogState(() => steps.add(RoutineStep(hobbyId: selectedId!, targetMinutes: mins)));
                Navigator.pop(innerCtx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
