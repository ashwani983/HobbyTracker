import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/log_session.dart';
import '../blocs/badge/badge_bloc.dart';
import '../blocs/session/session_bloc.dart';

class LogSessionScreen extends StatefulWidget {
  final String hobbyId;
  const LogSessionScreen({super.key, required this.hobbyId});

  @override
  State<LogSessionScreen> createState() => _LogSessionScreenState();
}

class _LogSessionScreenState extends State<LogSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  int? _rating;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionBloc(logSession: sl<LogSession>()),
      child: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionSaved) {
            // Trigger badge check after session saved
            context.read<BadgeBloc>().add(CheckNewBadges());
            context.pop();
          }
          if (state is SessionError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Log Session')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Date'),
                      subtitle: Text(
                        '${_date.month}/${_date.day}/${_date.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration (minutes)',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final n = int.tryParse(v);
                        if (n == null || n <= 0) {
                          return 'Must be a positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Text('Rating (optional)',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        final val = i + 1;
                        return IconButton(
                          icon: Icon(
                            val <= (_rating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => setState(
                            () => _rating = _rating == val ? null : val,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: state is SessionSaving
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
                              final session = Session(
                                id: const Uuid().v4(),
                                hobbyId: widget.hobbyId,
                                date: _date,
                                durationMinutes:
                                    int.parse(_durationController.text),
                                notes: _notesController.text.trim().isEmpty
                                    ? null
                                    : _notesController.text.trim(),
                                rating: _rating,
                                createdAt: DateTime.now(),
                              );
                              context
                                  .read<SessionBloc>()
                                  .add(LogSessionEvent(session));
                            },
                      child: state is SessionSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Session'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
