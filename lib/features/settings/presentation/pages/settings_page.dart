import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/settings/domain/entities/app_settings.dart';
import 'package:note_app/features/settings/presentation/cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _SectionHeader(title: 'Appearance'),
              _ThemeSelector(
                value: settings.themeMode,
                onChanged: (v) =>
                    context.read<SettingsCubit>().setThemeMode(v),
              ),
              const Divider(height: 32),
              _SectionHeader(title: 'Notes'),
              _SortOrderSelector(
                value: settings.sortOrder,
                onChanged: (v) =>
                    context.read<SettingsCubit>().setSortOrder(v),
              ),
              const SizedBox(height: 8),
              _FontSizeSelector(
                value: settings.fontSize,
                onChanged: (v) =>
                    context.read<SettingsCubit>().setFontSize(v),
              ),
              const Divider(height: 32),
              _SectionHeader(title: 'About'),
              _AboutTile(),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeModePreference value;
  final ValueChanged<ThemeModePreference> onChanged;

  const _ThemeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        const Text('Theme'),
        const SizedBox(height: 8),
        RadioGroup<ThemeModePreference>(
          groupValue: value,
          onChanged: (v) { if (v != null) onChanged(v); },
          child: Column(
            children: ThemeModePreference.values.map((mode) {
              return RadioListTile<ThemeModePreference>(
                value: mode,
                title: Text(_themeLabel(mode)),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _themeLabel(ThemeModePreference mode) {
    switch (mode) {
      case ThemeModePreference.system:
        return 'Follow system';
      case ThemeModePreference.light:
        return 'Light';
      case ThemeModePreference.dark:
        return 'Dark';
    }
  }
}

class _SortOrderSelector extends StatelessWidget {
  final SortOrder value;
  final ValueChanged<SortOrder> onChanged;

  const _SortOrderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        const Text('Sort notes by'),
        const SizedBox(height: 8),
        RadioGroup<SortOrder>(
          groupValue: value,
          onChanged: (v) { if (v != null) onChanged(v); },
          child: Column(
            children: SortOrder.values.map((order) {
              return RadioListTile<SortOrder>(
                value: order,
                title: Text(_sortLabel(order)),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _sortLabel(SortOrder order) {
    switch (order) {
      case SortOrder.dateNewest:
        return 'Newest first';
      case SortOrder.dateOldest:
        return 'Oldest first';
      case SortOrder.titleAZ:
        return 'Title A-Z';
      case SortOrder.titleZA:
        return 'Title Z-A';
    }
  }
}

class _FontSizeSelector extends StatelessWidget {
  final EditorFontSize value;
  final ValueChanged<EditorFontSize> onChanged;

  const _FontSizeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      children: [
        const Text('Editor font size'),
        const SizedBox(height: 8),
        RadioGroup<EditorFontSize>(
          groupValue: value,
          onChanged: (v) { if (v != null) onChanged(v); },
          child: Column(
            children: EditorFontSize.values.map((size) {
              return RadioListTile<EditorFontSize>(
                value: size,
                title: Row(
                  children: [
                    Text(_fontLabel(size)),
                    const Spacer(),
                    Text('Aa', style: TextStyle(fontSize: size.value)),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _fontLabel(EditorFontSize size) {
    switch (size) {
      case EditorFontSize.small:
        return 'Small';
      case EditorFontSize.medium:
        return 'Medium';
      case EditorFontSize.large:
        return 'Large';
    }
  }
}

class _AboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SettingCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Version'),
            Text(
              '0.1.0-dev.1',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Built with Clean Architecture, BLoC, and Flutter.',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
