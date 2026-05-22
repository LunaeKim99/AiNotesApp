import 'package:flutter/material.dart';

class WebviewToolbar extends StatelessWidget {
  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onUnderline;
  final VoidCallback onSave;

  const WebviewToolbar({
    super.key,
    required this.onBold,
    required this.onItalic,
    required this.onUnderline,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            onPressed: onBold,
            tooltip: 'Bold',
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.format_italic,
            onPressed: onItalic,
            tooltip: 'Italic',
          ),
          const SizedBox(width: 4),
          _ToolbarButton(
            icon: Icons.format_underline,
            onPressed: onUnderline,
            tooltip: 'Underline',
          ),
          const Spacer(),
          _ToolbarButton(
            icon: Icons.save,
            onPressed: onSave,
            tooltip: 'Save',
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? color;

  const _ToolbarButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
