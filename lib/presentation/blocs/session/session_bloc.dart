import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/usecases/log_session.dart';

// Events
abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class LogSessionEvent extends SessionEvent {
  final Session session;
  const LogSessionEvent(this.session);
  @override
  List<Object?> get props => [session.id];
}

// States
abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionSaving extends SessionState {}

class SessionSaved extends SessionState {}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final LogSession _logSession;

  SessionBloc({required LogSession logSession})
      : _logSession = logSession,
        super(SessionInitial()) {
    on<LogSessionEvent>(_onLog);
  }

  Future<void> _onLog(
    LogSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionSaving());
    try {
      await _logSession(event.session);
      emit(SessionSaved());
    } on ValidationFailure catch (e) {
      emit(SessionError(e.message));
    } on DatabaseFailure catch (e) {
      emit(SessionError(e.message));
    }
  }
}
