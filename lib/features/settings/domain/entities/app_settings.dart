import 'package:equatable/equatable.dart';

enum ThemeModePreference { system, light, dark }

enum SortOrder { dateNewest, dateOldest, titleAZ, titleZA }

enum EditorFontSize { small, medium, large }

extension EditorFontSizeX on EditorFontSize {
  double get value {
    switch (this) {
      case EditorFontSize.small:
        return 14;
      case EditorFontSize.medium:
        return 16;
      case EditorFontSize.large:
        return 20;
    }
  }
}

class AppSettings extends Equatable {
  final ThemeModePreference themeMode;
  final SortOrder sortOrder;
  final EditorFontSize fontSize;

  const AppSettings({
    this.themeMode = ThemeModePreference.system,
    this.sortOrder = SortOrder.dateNewest,
    this.fontSize = EditorFontSize.medium,
  });

  AppSettings copyWith({
    ThemeModePreference? themeMode,
    SortOrder? sortOrder,
    EditorFontSize? fontSize,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      sortOrder: sortOrder ?? this.sortOrder,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  List<Object?> get props => [themeMode, sortOrder, fontSize];
}
