import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/services/app_update_service.dart';

// States
abstract class UpdateState extends Equatable {
  const UpdateState();
  @override
  List<Object?> get props => [];
}

class UpdateInitial extends UpdateState {}

class UpdateChecking extends UpdateState {}

class UpdateAvailable extends UpdateState {
  final GitHubRelease release;
  const UpdateAvailable(this.release);
  @override
  List<Object?> get props => [release.tagName];
}

class UpdateNotAvailable extends UpdateState {}

class UpdateError extends UpdateState {
  final String message;
  const UpdateError(this.message);
  @override
  List<Object?> get props => [message];
}

class UpdateCubit extends Cubit<UpdateState> {
  final SharedPreferences _prefs;
  static const _dismissKey = 'update_dismissed_at';

  UpdateCubit(this._prefs) : super(UpdateInitial());

  Future<void> check({bool force = false}) async {
    if (!force) {
      final dismissed = _prefs.getInt(_dismissKey) ?? 0;
      final elapsed = DateTime.now().millisecondsSinceEpoch - dismissed;
      if (elapsed < const Duration(hours: 24).inMilliseconds) return;
    }
    emit(UpdateChecking());
    final release = await AppUpdateService.checkForUpdate();
    if (release != null) {
      emit(UpdateAvailable(release));
    } else {
      emit(UpdateNotAvailable());
    }
  }

  Future<void> dismiss() async {
    await _prefs.setInt(_dismissKey, DateTime.now().millisecondsSinceEpoch);
    emit(UpdateInitial());
  }
}
