import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<void> call(String id) {
    return repository.deleteNote(id);
  }
}
