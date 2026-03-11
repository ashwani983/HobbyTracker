import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../blocs/hobby_list/hobby_list_bloc.dart';

class HobbiesListScreen extends StatelessWidget {
  const HobbiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.hobbies)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/hobbies/add'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<HobbyListBloc, HobbyListState>(
        builder: (context, state) {
          if (state is HobbyListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HobbyListEmpty) {
            return Center(child: Text(l.noHobbiesYet));
          }
          if (state is HobbyListError) {
            return Center(child: Text(state.message));
          }
          final hobbies = (state as HobbyListLoaded).hobbies;
          return ListView.builder(
            itemCount: hobbies.length,
            itemBuilder: (context, i) {
              final hobby = hobbies[i];
              return Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => context
                          .read<HobbyListBloc>()
                          .add(ArchiveHobbyEvent(hobby.id)),
                      backgroundColor: Colors.red,
                      icon: Icons.archive,
                      label: l.archive,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(hobby.color),
                    child: Text(
                      AppConstants.emojiForCategory(hobby.category),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(hobby.name),
                  subtitle: Text(hobby.category),
                  onTap: () => context.go('/hobbies/${hobby.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
