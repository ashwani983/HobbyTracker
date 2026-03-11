import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/hobby.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/entities/suggestion.dart';
import '../../../domain/usecases/suggestion_engine.dart';

class SuggestionCubit extends Cubit<List<Suggestion>> {
  final SuggestionEngine _engine;
  SuggestionCubit(this._engine) : super(const []);

  void refresh({
    required List<Hobby> hobbies,
    required List<Session> recentSessions,
    required int streakDays,
  }) {
    emit(_engine.generate(
      hobbies: hobbies,
      recentSessions: recentSessions,
      streakDays: streakDays,
    ));
  }
}
