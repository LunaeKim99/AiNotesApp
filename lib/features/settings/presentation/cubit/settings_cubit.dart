import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/features/settings/domain/entities/app_settings.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit() : super(const AppSettings());

  static const String _key = 'app_settings';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      emit(AppSettings(
        themeMode: ThemeModePreference.values[map['themeMode'] as int? ?? 0],
        sortOrder: SortOrder.values[map['sortOrder'] as int? ?? 0],
        fontSize: EditorFontSize.values[map['fontSize'] as int? ?? 1],
      ));
    } catch (_) {
      // fallback ke default
    }
  }

  Future<void> _save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
      'themeMode': settings.themeMode.index,
      'sortOrder': settings.sortOrder.index,
      'fontSize': settings.fontSize.index,
    }));
  }

  Future<void> setThemeMode(ThemeModePreference mode) async {
    final updated = state.copyWith(themeMode: mode);
    emit(updated);
    await _save(updated);
  }

  Future<void> setSortOrder(SortOrder order) async {
    final updated = state.copyWith(sortOrder: order);
    emit(updated);
    await _save(updated);
  }

  Future<void> setFontSize(EditorFontSize size) async {
    final updated = state.copyWith(fontSize: size);
    emit(updated);
    await _save(updated);
  }
}
