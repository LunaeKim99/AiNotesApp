import 'package:uuid/uuid.dart';
import 'package:note_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:note_app/features/notes/data/models/note_model.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;
  final _uuid = const Uuid();

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Note>> getNotes() async {
    final models = await localDataSource.getNotes();
    models.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return models;
  }

  @override
  Future<Note> getNoteById(String id) async {
    return localDataSource.getNoteById(id);
  }

  @override
  Future<Note> createNote({
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();
    final model = NoteModel(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    return localDataSource.createNote(model);
  }

  @override
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
  }) async {
    final existing = await localDataSource.getNoteById(id);
    final model = existing.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );
    return localDataSource.updateNote(model);
  }

  @override
  Future<void> deleteNote(String id) async {
    return localDataSource.deleteNote(id);
  }

  @override
  Future<Note> togglePin(String id) async {
    final existing = await localDataSource.getNoteById(id);
    final model = existing.copyWith(
      isPinned: !existing.isPinned,
      updatedAt: DateTime.now(),
    );
    return localDataSource.updateNote(model);
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    final notes = await localDataSource.getNotes();
    final lowerQuery = query.toLowerCase();
    return notes
        .where((n) =>
            n.title.toLowerCase().contains(lowerQuery) ||
            n.content.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
  }
}
