import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/constants/app_constants.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/bloc/note_bloc.dart';
import 'package:note_app/features/notes/presentation/cubit/sidebar_cubit.dart';
import 'package:note_app/features/notes/presentation/pages/note_editor_page.dart';
import 'package:note_app/features/notes/presentation/widgets/note_tile.dart';
import 'package:note_app/features/notes/presentation/widgets/search_bar_widget.dart';
import 'package:note_app/features/notes/presentation/widgets/sidebar.dart';
import 'package:note_app/features/settings/domain/entities/app_settings.dart';
import 'package:note_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:note_app/features/settings/presentation/pages/settings_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(const LoadNotes());
  }

  void _addNote() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NoteEditorPage()),
    );
  }

  void _editNote(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NoteEditorPage(note: note)),
    );
  }

  void _deleteNote(Note note) {
    context.read<NoteBloc>().add(DeleteNoteEvent(id: note.id));
  }

  void _togglePin(Note note) {
    context.read<NoteBloc>().add(PinNoteEvent(id: note.id));
  }

  void _onSearch(String query) {
    context.read<NoteBloc>().add(SearchNotesEvent(query: query));
  }

  void _clearSearch() {
    context.read<NoteBloc>().add(const ClearSearchEvent());
    context.read<NoteBloc>().add(const LoadNotes());
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final layout = _ScreenLayout.fromWidth(screenWidth);

    return Scaffold(
      key: layout == _ScreenLayout.mobile ? _scaffoldKey : null,
      appBar: AppBar(
        title: Text('Notes'),
        leading: _buildLeading(layout),
      ),
      drawer: layout == _ScreenLayout.mobile ? _buildDrawer() : null,
      body: _buildBody(layout),
    );
  }

  Widget _buildLeading(_ScreenLayout layout) {
    if (layout == _ScreenLayout.mobile) {
      return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      );
    }

    return BlocBuilder<SidebarCubit, SidebarState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.isVisible ? Icons.menu_open : Icons.menu,
          ),
          onPressed: () => context.read<SidebarCubit>().toggle(),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            return Sidebar(
              width: AppConstants.sidebarWidthDesktop,
              notes: state.notes,
              onAddNote: () {
                Navigator.of(context).pop();
                _addNote();
              },
              onSelectNote: (id) {
                Navigator.of(context).pop();
                final note = state.notes.where((n) => n.id == id).firstOrNull;
                if (note != null) _editNote(note);
              },
              onOpenSettings: () {
                Navigator.of(context).pop();
                _openSettings();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(_ScreenLayout layout) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (layout == _ScreenLayout.mobile) {
          return _buildNotesContent(state);
        }

        final sidebarWidth = layout == _ScreenLayout.tablet
            ? AppConstants.sidebarWidthTablet
            : AppConstants.sidebarWidthDesktop;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Sidebar(
              width: sidebarWidth,
              notes: state.notes,
              onAddNote: _addNote,
              onSelectNote: (id) {
                final note = state.notes.where((n) => n.id == id).firstOrNull;
                if (note != null) _editNote(note);
              },
              onOpenSettings: _openSettings,
            ),
            Expanded(child: _buildNotesContent(state)),
          ],
        );
      },
    );
  }

  Widget _buildNotesContent(NoteState state) {
    final theme = Theme.of(context);

    if (state.isLoading && state.notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<NoteBloc>().add(const LoadNotes()),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final isSearching =
        state.searchQuery != null && state.searchQuery!.isNotEmpty;
    final settings = context.watch<SettingsCubit>().state;
    var displayNotes = isSearching
        ? state.notes
            .where((n) => _noteMatchesSearch(n, state.searchQuery!))
            .toList()
        : List<Note>.from(state.notes);

    displayNotes.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      switch (settings.sortOrder) {
        case SortOrder.dateNewest:
          return b.updatedAt.compareTo(a.updatedAt);
        case SortOrder.dateOldest:
          return a.updatedAt.compareTo(b.updatedAt);
        case SortOrder.titleAZ:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOrder.titleZA:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
      }
    });

    return Column(
      children: [
        NoteSearchBar(
          initialValue: state.searchQuery,
          onChanged: _onSearch,
          onClear: _clearSearch,
        ),
        if (isSearching && displayNotes.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No results for "${state.searchQuery}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          )
        else if (!isSearching && displayNotes.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.note_add_outlined,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _addNote,
                    icon: const Icon(Icons.add),
                    label: const Text('Create your first note'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<NoteBloc>().add(const LoadNotes());
              },
              child: ListView.builder(
                itemCount: displayNotes.length,
                itemBuilder: (_, i) {
                  final note = displayNotes[i];
                  return NoteTile(
                    note: note,
                    onTap: () => _editNote(note),
                    onPin: () => _togglePin(note),
                    onDelete: () => _deleteNote(note),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  bool _noteMatchesSearch(Note note, String query) {
    final q = query.toLowerCase();
    return note.title.toLowerCase().contains(q) ||
        note.content.toLowerCase().contains(q);
  }
}

enum _ScreenLayout {
  mobile,
  tablet,
  desktop;

  static _ScreenLayout fromWidth(double width) {
    if (width < AppConstants.mobileBreakpoint) return _ScreenLayout.mobile;
    if (width < AppConstants.tabletBreakpoint) return _ScreenLayout.tablet;
    return _ScreenLayout.desktop;
  }
}
