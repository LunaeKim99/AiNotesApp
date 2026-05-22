import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note_app/features/notes/data/models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> getNoteById(String id);
  Future<NoteModel> createNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  static const String _storageKey = 'notes';

  NoteLocalDataSourceImpl();

  @override
  Future<List<NoteModel>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data == null) return [];
    final list = jsonDecode(data) as List<dynamic>;
    return list.map((e) => NoteModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    final notes = await getNotes();
    return notes.firstWhere((n) => n.id == id);
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    final notes = await getNotes();
    notes.add(note);
    await _saveNotes(notes);
    return note;
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index == -1) throw Exception('Note not found');
    notes[index] = note;
    await _saveNotes(notes);
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await _saveNotes(notes);
  }

  Future<void> _saveNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, data);
  }
}
