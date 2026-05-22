import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/widgets/empty_state_view.dart';
import 'package:note_app/core/widgets/loading_view.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/notes/presentation/widgets/note_card.dart';
import 'package:note_app/core/constants/app_strings.dart';

class NotesList extends StatelessWidget {
  final void Function(Note note) onEditNote;
  final void Function(Note note) onTogglePin;
  final void Function(Note note) onDeleteNote;
  final VoidCallback onCreateNote;

  const NotesList({
    super.key,
    required this.onEditNote,
    required this.onTogglePin,
    required this.onDeleteNote,
    required this.onCreateNote,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state.isLoading && state.notes.isEmpty) {
          return const LoadingView();
        }

        if (state.error != null && state.notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${AppStrings.errorOccurred}: ${state.error}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      context.read<NoteBloc>().add(const LoadNotes()),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        if (state.notes.isEmpty && state.searchQuery == null) {
          return EmptyStateView(
            message: AppStrings.emptyState,
            actionLabel: AppStrings.emptyStateAction,
            onAction: onCreateNote,
          );
        }

        final pinnedNotes = state.notes.where((n) => n.isPinned).toList();
        final unpinnedNotes = state.notes.where((n) => !n.isPinned).toList();

        if (state.notes.isEmpty && state.searchQuery != null) {
          return EmptyStateView(
            message: '${AppStrings.noResults} for "${state.searchQuery}"',
            icon: Icons.search_off,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<NoteBloc>().add(const LoadNotes());
          },
          child: CustomScrollView(
            slivers: [
              if (pinnedNotes.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      AppStrings.pinned,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: _gridDelegate(context),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => NoteCard(
                      note: pinnedNotes[i],
                      onTap: () => onEditNote(pinnedNotes[i]),
                      onLongPress: () => _showContextMenu(
                          context, pinnedNotes[i], onTogglePin, onDeleteNote),
                    ),
                    childCount: pinnedNotes.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(height: 24),
                ),
              ],
              if (unpinnedNotes.isNotEmpty) ...[
                if (pinnedNotes.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Text(
                        AppStrings.allNotes,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                              letterSpacing: 1,
                            ),
                      ),
                    ),
                  ),
                SliverGrid(
                  gridDelegate: _gridDelegate(context),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => NoteCard(
                      note: unpinnedNotes[i],
                      onTap: () => onEditNote(unpinnedNotes[i]),
                      onLongPress: () => _showContextMenu(
                          context, unpinnedNotes[i], onTogglePin, onDeleteNote),
                    ),
                    childCount: unpinnedNotes.length,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  SliverGridDelegate _gridDelegate(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (width < 600) {
      crossAxisCount = 2;
    } else if (width < 900) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.9,
    );
  }

  void _showContextMenu(
    BuildContext context,
    Note note,
    void Function(Note note) onTogglePin,
    void Function(Note note) onDeleteNote,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(note.isPinned ? AppStrings.unpin : AppStrings.pin),
              onTap: () {
                Navigator.pop(ctx);
                onTogglePin(note);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(AppStrings.deleteNote),
              onTap: () {
                Navigator.pop(ctx);
                onDeleteNote(note);
              },
            ),
          ],
        ),
      ),
    );
  }
}
