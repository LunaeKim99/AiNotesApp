import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/usecases/create_note.dart';
import 'package:note_app/features/notes/domain/usecases/delete_note.dart';
import 'package:note_app/features/notes/domain/usecases/get_notes.dart';
import 'package:note_app/features/notes/domain/usecases/pin_note.dart';
import 'package:note_app/features/notes/domain/usecases/search_notes.dart';
import 'package:note_app/features/notes/domain/usecases/update_note.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';

class MockGetNotes extends Mock implements GetNotes {}
class MockCreateNote extends Mock implements CreateNote {}
class MockUpdateNote extends Mock implements UpdateNote {}
class MockDeleteNote extends Mock implements DeleteNote {}
class MockPinNote extends Mock implements PinNote {}
class MockSearchNotes extends Mock implements SearchNotes {}

void main() {
  late GetNotes mockGetNotes;
  late CreateNote mockCreateNote;
  late UpdateNote mockUpdateNote;
  late DeleteNote mockDeleteNote;
  late PinNote mockPinNote;
  late SearchNotes mockSearchNotes;
  late NoteBloc noteBloc;

  final tNote = Note(
    id: '1',
    title: 'Test',
    content: 'Content',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockGetNotes = MockGetNotes();
    mockCreateNote = MockCreateNote();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();
    mockPinNote = MockPinNote();
    mockSearchNotes = MockSearchNotes();

    noteBloc = NoteBloc(
      getNotes: mockGetNotes,
      createNote: mockCreateNote,
      updateNote: mockUpdateNote,
      deleteNote: mockDeleteNote,
      pinNote: mockPinNote,
      searchNotes: mockSearchNotes,
    );
  });

  tearDown(() {
    noteBloc.close();
  });

  group('NoteBloc', () {
    test('initial state is NoteState.initial()', () {
      expect(noteBloc.state, NoteState.initial());
    });

    blocTest<NoteBloc, NoteState>(
      'emits [loading, loaded] when LoadNotes succeeds',
      setUp: () {
        when(() => mockGetNotes.call()).thenAnswer((_) async => [tNote]);
      },
      build: () => noteBloc,
      act: (bloc) => bloc.add(const LoadNotes()),
      expect: () => [
        NoteState.initial().copyWith(isLoading: true),
        NoteState.initial().copyWith(notes: [tNote], isLoading: false),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'emits [loading, error] when LoadNotes fails',
      setUp: () {
        when(() => mockGetNotes.call()).thenThrow(Exception('Failed'));
      },
      build: () => noteBloc,
      act: (bloc) => bloc.add(const LoadNotes()),
      expect: () => [
        NoteState.initial().copyWith(isLoading: true),
        NoteState.initial().copyWith(isLoading: false, error: 'Exception: Failed'),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'creates note and reloads on CreateNoteEvent',
      setUp: () {
        when(() => mockCreateNote.call(title: any(named: 'title'), content: any(named: 'content')))
            .thenAnswer((_) async => tNote);
        when(() => mockGetNotes.call()).thenAnswer((_) async => [tNote]);
      },
      build: () => noteBloc,
      act: (bloc) => bloc.add(const CreateNoteEvent(title: 'Test', content: 'Content')),
      expect: () => [
        NoteState.initial().copyWith(notes: [tNote], error: null),
      ],
    );

    blocTest<NoteBloc, NoteState>(
      'deletes note and reloads on DeleteNoteEvent',
      setUp: () {
        when(() => mockDeleteNote.call(any())).thenAnswer((_) async {});
        when(() => mockGetNotes.call()).thenAnswer((_) async => []);
      },
      build: () => noteBloc,
      seed: () => NoteState.initial().copyWith(
        notes: [tNote],
        isLoading: false,
      ),
      act: (bloc) => bloc.add(const DeleteNoteEvent(id: '1')),
      expect: () => [
        NoteState.initial().copyWith(notes: [], error: null),
      ],
    );
  });
}
