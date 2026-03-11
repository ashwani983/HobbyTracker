import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/goal_type.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/usecases/get_active_hobbies.dart';
import '../blocs/goal/goal_bloc.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  List<Hobby> _hobbies = [];
  String? _selectedHobbyId;
  GoalType _type = GoalType.weekly;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    _loadHobbies();
  }

  Future<void> _loadHobbies() async {
    final hobbies = await sl<GetActiveHobbies>()();
    if (mounted) {
      setState(() {
        _hobbies = hobbies;
        if (hobbies.isNotEmpty) _selectedHobbyId = hobbies.first.id;
      });
    }
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_hobbies.isEmpty)
                const Text('Add a hobby first.')
              else
                DropdownButtonFormField<String>(
                  initialValue: _selectedHobbyId,
                  decoration: const InputDecoration(labelText: 'Hobby'),
                  items: _hobbies
                      .map((h) =>
                          DropdownMenuItem(value: h.id, child: Text(h.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedHobbyId = v),
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<GoalType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: GoalType.values
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetController,
                decoration: const InputDecoration(
                  labelText: 'Target (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Must be positive';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(
                  '${_startDate.month}/${_startDate.day}/${_startDate.year}',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
              ),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  '${_endDate.month}/${_endDate.day}/${_endDate.year}',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _endDate = picked);
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _selectedHobbyId == null
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) return;
                        if (!_endDate.isAfter(_startDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('End date must be after start date'),
                            ),
                          );
                          return;
                        }
                        final goal = Goal(
                          id: const Uuid().v4(),
                          hobbyId: _selectedHobbyId!,
                          type: _type,
                          targetDurationMinutes:
                              int.parse(_targetController.text),
                          startDate: _startDate,
                          endDate: _endDate,
                        );
                        context.read<GoalBloc>().add(CreateGoalEvent(goal));
                        context.pop();
                      },
                child: const Text('Create Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
