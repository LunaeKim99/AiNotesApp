import 'package:note_app/features/notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<Note> createNote({required String title, required String content});
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
  });
  Future<void> deleteNote(String id);
  Future<Note> togglePin(String id);
  Future<List<Note>> searchNotes(String query);
}
