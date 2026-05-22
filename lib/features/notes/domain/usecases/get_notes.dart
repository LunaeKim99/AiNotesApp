import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class GetNotes {
  final NoteRepository repository;

  GetNotes(this.repository);

  Future<List<Note>> call() {
    return repository.getNotes();
  }
}
