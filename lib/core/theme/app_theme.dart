import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        drawerTheme: const DrawerThemeData(width: 280),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        drawerTheme: const DrawerThemeData(width: 280),
      );
}
