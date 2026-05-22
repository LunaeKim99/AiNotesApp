import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class SearchNotes {
  final NoteRepository repository;

  SearchNotes(this.repository);

  Future<List<Note>> call(String query) {
    return repository.searchNotes(query);
  }
}
