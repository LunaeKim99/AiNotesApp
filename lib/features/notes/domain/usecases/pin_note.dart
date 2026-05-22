import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class PinNote {
  final NoteRepository repository;

  PinNote(this.repository);

  Future<Note> call(String id) {
    return repository.togglePin(id);
  }
}
