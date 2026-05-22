import 'package:get_it/get_it.dart';
import 'package:note_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:note_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';
import 'package:note_app/features/notes/domain/usecases/create_note.dart';
import 'package:note_app/features/notes/domain/usecases/delete_note.dart';
import 'package:note_app/features/notes/domain/usecases/get_notes.dart';
import 'package:note_app/features/notes/domain/usecases/pin_note.dart';
import 'package:note_app/features/notes/domain/usecases/search_notes.dart';
import 'package:note_app/features/notes/domain/usecases/update_note.dart';
import 'package:note_app/features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => PinNote(sl()));
  sl.registerLazySingleton(() => SearchNotes(sl()));

  // Settings Cubit — not registered as singleton, created in BlocProvider
  // but we can pre-load settings
  final settingsCubit = SettingsCubit();
  sl.registerLazySingleton<SettingsCubit>(() => settingsCubit);
  await settingsCubit.load();
}
