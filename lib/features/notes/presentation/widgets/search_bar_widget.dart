import 'package:flutter/material.dart';

class NoteSearchBar extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const NoteSearchBar({
    super.key,
    this.initialValue,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search notes...',
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.outline),
          suffixIcon: initialValue != null && initialValue!.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: theme.colorScheme.outline),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}
