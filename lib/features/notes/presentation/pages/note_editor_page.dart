import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _titleController.addListener(_markChanged);
    _contentController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    if (widget.note == null) {
      context.read<NoteBloc>().add(CreateNoteEvent(title: title, content: content));
    } else {
      context.read<NoteBloc>().add(UpdateNoteEvent(
            id: widget.note!.id,
            title: title,
            content: content,
          ));
    }
    _hasChanges = false;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (_hasChanges)
            TextButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  style: theme.textTheme.titleLarge,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
                Divider(color: theme.colorScheme.outlineVariant),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: theme.textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Start writing...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
