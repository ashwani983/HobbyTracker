import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale?> {
  final SharedPreferences _prefs;
  static const _key = 'locale';

  LocaleCubit(this._prefs) : super(_load(_prefs));

  static Locale? _load(SharedPreferences p) {
    final code = p.getString(_key);
    return code != null ? Locale(code) : null;
  }

  void setLocale(Locale? locale) {
    if (locale == null) {
      _prefs.remove(_key);
    } else {
      _prefs.setString(_key, locale.languageCode);
    }
    emit(locale);
  }
}
