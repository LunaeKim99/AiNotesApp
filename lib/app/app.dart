import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/di/injection.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/notes/presentation/cubit/sidebar_cubit.dart';
import 'package:note_app/features/notes/presentation/pages/notes_page.dart';
import 'package:note_app/features/settings/domain/entities/app_settings.dart';
import 'package:note_app/features/settings/presentation/cubit/settings_cubit.dart';

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SidebarCubit()),
        BlocProvider(
          create: (_) => NoteBloc(
            getNotes: sl(),
            createNote: sl(),
            updateNote: sl(),
            deleteNote: sl(),
            pinNote: sl(),
            searchNotes: sl(),
          ),
        ),
        BlocProvider.value(value: sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            title: 'Note App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _resolveThemeMode(settings.themeMode),
            home: const NotesPage(),
          );
        },
      ),
    );
  }

  ThemeMode _resolveThemeMode(ThemeModePreference preference) {
    switch (preference) {
      case ThemeModePreference.light:
        return ThemeMode.light;
      case ThemeModePreference.dark:
        return ThemeMode.dark;
      case ThemeModePreference.system:
        return ThemeMode.system;
    }
  }
}
