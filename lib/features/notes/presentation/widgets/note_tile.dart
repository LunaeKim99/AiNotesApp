import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const NoteTile({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('MMM d, yyyy').format(note.updatedAt);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: note.isPinned
            ? const Icon(Icons.push_pin, color: Colors.amber, size: 20)
            : null,
        title: Text(
          note.title.isEmpty ? 'Untitled' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: note.isPinned ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.content.isNotEmpty)
              Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              dateStr,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 18),
          onSelected: (value) {
            if (value == 'pin') onPin();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'pin',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(note.isPinned ? 'Unpin' : 'Pin'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
