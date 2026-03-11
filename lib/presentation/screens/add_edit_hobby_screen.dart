import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/hobby.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/usecases/update_hobby.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';

class AddEditHobbyScreen extends StatefulWidget {
  final String? hobbyId;
  const AddEditHobbyScreen({super.key, this.hobbyId});

  @override
  State<AddEditHobbyScreen> createState() => _AddEditHobbyScreenState();
}

class _AddEditHobbyScreenState extends State<AddEditHobbyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _category = AppConstants.categories.first;
  Color _color = Colors.blue;
  bool _isLoading = false;
  Hobby? _existing;

  static const _colorOptions = [
    Colors.blue, Colors.red, Colors.green, Colors.orange,
    Colors.purple, Colors.teal, Colors.pink, Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.hobbyId != null) _loadHobby();
  }

  Future<void> _loadHobby() async {
    final hobby = await sl<HobbyRepository>().getHobbyById(widget.hobbyId!);
    if (hobby != null && mounted) {
      setState(() {
        _existing = hobby;
        _nameController.text = hobby.name;
        _descController.text = hobby.description ?? '';
        _category = hobby.category;
        _color = Color(hobby.color);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final hobby = Hobby(
      id: _existing?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      description:
          _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      category: _category,
      iconName: 'interests',
      color: _color.toARGB32(),
      createdAt: _existing?.createdAt ?? DateTime.now(),
    );

    try {
      if (_existing != null) {
        await sl<UpdateHobby>()(hobby);
      } else {
        context.read<HobbyListBloc>().add(CreateHobbyEvent(hobby));
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isEdit = widget.hobbyId != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l.editHobby : l.addHobby)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l.name),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.nameRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: l.description),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(labelText: l.category),
                items: AppConstants.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 12),
              Text(l.color, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colorOptions.map((c) {
                  return GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: CircleAvatar(
                      backgroundColor: c,
                      radius: 18,
                      child: _color.toARGB32() == c.toARGB32()
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? l.update : l.create),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
