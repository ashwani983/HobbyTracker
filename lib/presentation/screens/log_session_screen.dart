import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/usecases/attach_photos.dart';
import '../../domain/usecases/log_session.dart';
import '../../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/badge/badge_bloc.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
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
  final _attachPhotos = AttachPhotos();
  final _photoPaths = <String>[];
  int? _rating;
  DateTime _date = DateTime.now();
  late bool _syncToCalendar;

  @override
  void initState() {
    super.initState();
    _syncToCalendar = sl<SharedPreferences>().getBool('calendar_sync') ?? false;
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    if (_photoPaths.length >= 5) return;
    final paths = await _attachPhotos.fromGallery(
      maxImages: 5 - _photoPaths.length,
    );
    if (paths.isNotEmpty) setState(() => _photoPaths.addAll(paths));
  }

  Future<void> _pickFromCamera() async {
    if (_photoPaths.length >= 5) return;
    final path = await _attachPhotos.fromCamera();
    if (path != null) setState(() => _photoPaths.add(path));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SessionBloc(logSession: sl<LogSession>()),
      child: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) async {
          if (state is SessionSaved) {
            final badgeBloc = context.read<BadgeBloc>();
            final dashBloc = context.read<DashboardBloc>();
            final nav = GoRouter.of(context);
            if (_syncToCalendar) {
              final hobby = await sl<HobbyRepository>().getHobbyById(widget.hobbyId);
              if (hobby != null) {
                await sl<CalendarRepository>().syncSessionToCalendar(
                  Session(
                    id: '',
                    hobbyId: widget.hobbyId,
                    date: _date,
                    durationMinutes: int.tryParse(_durationController.text) ?? 0,
                    createdAt: DateTime.now(),
                  ),
                  hobby.name,
                );
              }
            }
            badgeBloc.add(CheckNewBadges());
            dashBloc.add(LoadDashboard());
            nav.pop();
          }
          if (state is SessionError) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(l.logSession)),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(l.date),
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
                      decoration: InputDecoration(labelText: l.durationMinutesLabel),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return l.required;
                        final n = int.tryParse(v);
                        if (n == null || n <= 0) return l.mustBePositive;
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(labelText: l.notes),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    Text(l.ratingOptional,
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
                    const SizedBox(height: 16),
                    Text(l.photosCount(_photoPaths.length),
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _photoPaths.length >= 5 ? null : _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: Text(l.gallery),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _photoPaths.length >= 5 ? null : _pickFromCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: Text(l.camera),
                        ),
                      ],
                    ),
                    if (_photoPaths.isNotEmpty)
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photoPaths.length,
                          separatorBuilder: (_, i2) => const SizedBox(width: 8),
                          itemBuilder: (_, i) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_photoPaths[i]),
                                  width: 80, height: 80, fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0, right: 0,
                                child: GestureDetector(
                                  onTap: () => setState(() => _photoPaths.removeAt(i)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54, shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SwitchListTile(
                      secondary: const Icon(Icons.calendar_month),
                      title: const Text('Add to Calendar'),
                      value: _syncToCalendar,
                      onChanged: (v) => setState(() => _syncToCalendar = v),
                    ),
                    const SizedBox(height: 12),
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
                                photoPaths: _photoPaths,
                                createdAt: DateTime.now(),
                              );
                              context
                                  .read<SessionBloc>()
                                  .add(LogSessionEvent(session));
                            },
                      child: state is SessionSaving
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.saveSession),
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
