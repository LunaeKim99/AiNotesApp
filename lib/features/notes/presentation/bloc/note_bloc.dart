import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/domain/usecases/create_note.dart';
import 'package:note_app/features/notes/domain/usecases/delete_note.dart';
import 'package:note_app/features/notes/domain/usecases/get_notes.dart';
import 'package:note_app/features/notes/domain/usecases/pin_note.dart';
import 'package:note_app/features/notes/domain/usecases/search_notes.dart';
import 'package:note_app/features/notes/domain/usecases/update_note.dart';

// ─── Events ────────────────────────────────────────────────

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {
  const LoadNotes();
}

class CreateNoteEvent extends NoteEvent {
  final String title;
  final String content;

  const CreateNoteEvent({required this.title, this.content = ''});

  @override
  List<Object?> get props => [title, content];
}

class UpdateNoteEvent extends NoteEvent {
  final String id;
  final String? title;
  final String? content;

  const UpdateNoteEvent({required this.id, this.title, this.content});

  @override
  List<Object?> get props => [id, title, content];
}

class DeleteNoteEvent extends NoteEvent {
  final String id;

  const DeleteNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class PinNoteEvent extends NoteEvent {
  final String id;

  const PinNoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SearchNotesEvent extends NoteEvent {
  final String query;

  const SearchNotesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends NoteEvent {
  const ClearSearchEvent();
}

// ─── State ─────────────────────────────────────────────────

class NoteState extends Equatable {
  final List<Note> notes;
  final bool isLoading;
  final String? error;
  final String? searchQuery;

  const NoteState({
    required this.notes,
    required this.isLoading,
    this.error,
    this.searchQuery,
  });

  factory NoteState.initial() => const NoteState(
        notes: [],
        isLoading: false,
        error: null,
        searchQuery: null,
      );

  NoteState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool clearError = false,
    bool clearSearch = false,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
    );
  }

  @override
  List<Object?> get props => [notes, isLoading, error, searchQuery];
}

// ─── BLoC ──────────────────────────────────────────────────

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotes getNotes;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final PinNote pinNote;
  final SearchNotes searchNotes;

  NoteBloc({
    required this.getNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.pinNote,
    required this.searchNotes,
  }) : super(NoteState.initial()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<PinNoteEvent>(_onPinNote);
    on<SearchNotesEvent>(_onSearchNotes);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final notes = await getNotes.call();
      emit(state.copyWith(notes: notes, isLoading: false, error: null, searchQuery: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateNote(CreateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await createNote.call(title: event.title, content: event.content);
      final notes = await getNotes.call();
      emit(state.copyWith(notes: notes, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await updateNote.call(id: event.id, title: event.title, content: event.content);
      final notes = await getNotes.call();
      emit(state.copyWith(notes: notes, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await deleteNote.call(event.id);
      final notes = await getNotes.call();
      emit(state.copyWith(notes: notes, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onPinNote(PinNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await pinNote.call(event.id);
      final notes = await getNotes.call();
      emit(state.copyWith(notes: notes, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onSearchNotes(SearchNotesEvent event, Emitter<NoteState> emit) async {
    emit(state.copyWith(searchQuery: event.query, isLoading: true));
    try {
      if (event.query.isEmpty) {
        final notes = await getNotes.call();
        emit(state.copyWith(notes: notes, isLoading: false, searchQuery: ''));
      } else {
        final notes = await searchNotes.call(event.query);
        emit(state.copyWith(notes: notes, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<NoteState> emit) {
    emit(state.copyWith(searchQuery: null));
  }
}
