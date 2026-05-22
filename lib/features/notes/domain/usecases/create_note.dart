import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';

class CreateNote {
  final NoteRepository repository;

  CreateNote(this.repository);

  Future<Note> call({required String title, required String content}) {
    return repository.createNote(title: title, content: content);
  }
}
