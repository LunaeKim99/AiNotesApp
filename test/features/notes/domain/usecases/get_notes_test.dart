import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/repositories/note_repository.dart';
import 'package:note_app/features/notes/domain/usecases/get_notes.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

void main() {
  late GetNotes usecase;
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
    usecase = GetNotes(mockRepository);
  });

  final tNotes = [
    Note(
      id: '1',
      title: 'Note 1',
      content: 'Content 1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Note(
      id: '2',
      title: 'Note 2',
      content: 'Content 2',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  test('should return list of notes from repository', () async {
    when(() => mockRepository.getNotes()).thenAnswer((_) async => tNotes);

    final result = await usecase.call();

    expect(result, tNotes);
    verify(() => mockRepository.getNotes()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when repository returns empty', () async {
    when(() => mockRepository.getNotes()).thenAnswer((_) async => []);

    final result = await usecase.call();

    expect(result, []);
    verify(() => mockRepository.getNotes()).called(1);
  });

  test('should throw exception when repository fails', () async {
    when(() => mockRepository.getNotes()).thenThrow(Exception('Failed'));

    expect(() => usecase.call(), throwsA(isA<Exception>()));
    verify(() => mockRepository.getNotes()).called(1);
  });
}
