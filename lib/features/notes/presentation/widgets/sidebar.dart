import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/constants/app_constants.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/cubit/sidebar_cubit.dart';

class Sidebar extends StatelessWidget {
  final List<Note> notes;
  final String? selectedNoteId;
  final VoidCallback onAddNote;
  final ValueChanged<String> onSelectNote;
  final VoidCallback? onOpenSettings;
  final double width;

  const Sidebar({
    super.key,
    required this.notes,
    this.selectedNoteId,
    required this.onAddNote,
    required this.onSelectNote,
    this.onOpenSettings,
    this.width = AppConstants.sidebarWidthDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pinnedNotes = notes.where((n) => n.isPinned).toList();

    return BlocBuilder<SidebarCubit, SidebarState>(
      builder: (context, state) {
        final isVisible = state.isVisible;
        return AnimatedContainer(
          duration: AppConstants.sidebarAnimationDuration,
          width: isVisible ? width : 0,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: Border(
              right: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: isVisible
              ? Column(
                  children: [
                    _Header(onAddNote: onAddNote),
                    Divider(color: theme.colorScheme.outlineVariant),
                    if (pinnedNotes.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: Text(
                          'PINNED',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      ...pinnedNotes.map((note) => _NoteListItem(
                            note: note,
                            isSelected: note.id == selectedNoteId,
                            onTap: () => onSelectNote(note.id),
                          )),
                      Divider(color: theme.colorScheme.outlineVariant),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text(
                        'ALL NOTES',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) => _NoteListItem(
                          note: notes[i],
                          isSelected: notes[i].id == selectedNoteId,
                          onTap: () => onSelectNote(notes[i].id),
                        ),
                      ),
                    ),
                    Divider(color: theme.colorScheme.outlineVariant),
                    _Footer(onOpenSettings: onOpenSettings),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAddNote;

  const _Header({required this.onAddNote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Icon(Icons.note_alt_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Notes',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddNote,
            tooltip: 'New note',
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback? onOpenSettings;

  const _Footer({this.onOpenSettings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      leading: Icon(Icons.settings_outlined,
          size: 18, color: theme.colorScheme.onSurfaceVariant),
      title: Text(
        'Settings',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onOpenSettings,
    );
  }
}

class _NoteListItem extends StatelessWidget {
  final Note note;
  final bool isSelected;
  final VoidCallback onTap;

  const _NoteListItem({
    required this.note,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      leading: note.isPinned
          ? Icon(Icons.push_pin, size: 16, color: theme.colorScheme.primary)
          : null,
      title: Text(
        note.title.isEmpty ? 'Untitled' : note.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}
