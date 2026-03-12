import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighContrastCubit extends Cubit<bool> {
  static const _key = 'high_contrast';
  final SharedPreferences _prefs;

  HighContrastCubit(this._prefs) : super(_prefs.getBool(_key) ?? false);

  void toggle() {
    final v = !state;
    _prefs.setBool(_key, v);
    emit(v);
  }
}
