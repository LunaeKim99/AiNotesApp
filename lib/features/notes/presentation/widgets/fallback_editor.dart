import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';
import 'package:note_app/core/constants/app_strings.dart';

class FallbackEditor extends StatefulWidget {
  final Note? note;

  const FallbackEditor({super.key, this.note});

  @override
  State<FallbackEditor> createState() => _FallbackEditorState();
}

class _FallbackEditorState extends State<FallbackEditor> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            style: theme.textTheme.titleLarge,
            decoration: const InputDecoration(
              hintText: AppStrings.titleHint,
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
                hintText: AppStrings.contentHint,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text(AppStrings.save),
            ),
          ),
        ],
      ),
    );
  }
}
