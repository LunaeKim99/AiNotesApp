import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  Future<Note> call({
    required String id,
    String? title,
    String? content,
  }) {
    return repository.updateNote(id: id, title: title, content: content);
  }
}
