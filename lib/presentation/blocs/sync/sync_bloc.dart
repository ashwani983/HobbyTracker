import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/usecases/sync_from_cloud.dart';
import '../../../domain/usecases/sync_to_cloud.dart';

// Events
abstract class SyncEvent extends Equatable {
  const SyncEvent();
  @override
  List<Object?> get props => [];
}

class SyncNow extends SyncEvent {
  final String userId;
  const SyncNow(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ToggleSync extends SyncEvent {
  final bool enabled;
  const ToggleSync(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class LoadSyncPref extends SyncEvent {}

// States
abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

class SyncIdle extends SyncState {
  final bool enabled;
  const SyncIdle({this.enabled = false});
  @override
  List<Object?> get props => [enabled];
}

class Syncing extends SyncState {}

class SyncDone extends SyncState {
  final bool enabled;
  const SyncDone({this.enabled = true});
  @override
  List<Object?> get props => [enabled];
}

class SyncError extends SyncState {
  final String message;
  const SyncError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncToCloud _toCloud;
  final SyncFromCloud _fromCloud;
  final SharedPreferences _prefs;

  static const _key = 'sync_enabled';

  SyncBloc({
    required SyncToCloud toCloud,
    required SyncFromCloud fromCloud,
    required SharedPreferences prefs,
  })  : _toCloud = toCloud,
        _fromCloud = fromCloud,
        _prefs = prefs,
        super(const SyncIdle()) {
    on<LoadSyncPref>(_onLoadPref);
    on<ToggleSync>(_onToggle);
    on<SyncNow>(_onSync);
  }

  Future<void> _onLoadPref(LoadSyncPref e, Emitter<SyncState> emit) async {
    final enabled = _prefs.getBool(_key) ?? false;
    emit(SyncIdle(enabled: enabled));
  }

  Future<void> _onToggle(ToggleSync e, Emitter<SyncState> emit) async {
    await _prefs.setBool(_key, e.enabled);
    emit(SyncIdle(enabled: e.enabled));
  }

  Future<void> _onSync(SyncNow e, Emitter<SyncState> emit) async {
    emit(Syncing());
    try {
      await _toCloud(e.userId);
      await _fromCloud(e.userId);
      emit(const SyncDone());
    } catch (err) {
      emit(SyncError(err.toString()));
    }
  }
}
