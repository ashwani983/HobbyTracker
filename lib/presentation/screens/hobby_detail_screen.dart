import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../domain/repositories/hobby_repository.dart';
import '../../domain/usecases/get_sessions_by_hobby.dart';
import '../blocs/hobby_detail/hobby_detail_bloc.dart';

class HobbyDetailScreen extends StatelessWidget {
  final String hobbyId;
  const HobbyDetailScreen({super.key, required this.hobbyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HobbyDetailBloc(
        hobbyRepository: sl<HobbyRepository>(),
        getSessionsByHobby: sl<GetSessionsByHobby>(),
      )..add(LoadHobbyDetail(hobbyId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hobby Detail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.go('/hobbies/$hobbyId/edit'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/hobbies/$hobbyId/log'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<HobbyDetailBloc, HobbyDetailState>(
          builder: (context, state) {
            if (state is HobbyDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HobbyDetailError) {
              return Center(child: Text(state.message));
            }
            final s = state as HobbyDetailLoaded;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(s.hobby.name,
                    style: Theme.of(context).textTheme.headlineSmall),
                if (s.hobby.description != null) ...[
                  const SizedBox(height: 8),
                  Text(s.hobby.description!),
                ],
                const SizedBox(height: 8),
                Chip(label: Text(s.hobby.category)),
                const SizedBox(height: 16),
                Text('Sessions',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (s.sessions.isEmpty)
                  const Text('No sessions yet.')
                else
                  ...s.sessions.map(
                    (session) => ListTile(
                      title: Text('${session.durationMinutes} min'),
                      subtitle: Text(
                        '${session.date.month}/${session.date.day}/${session.date.year}',
                      ),
                      trailing: session.rating != null
                          ? Text('⭐ ${session.rating}')
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
