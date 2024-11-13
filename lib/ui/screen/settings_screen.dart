import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/language_state.dart';
import '../../states/theme_mode_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).themeMode;
    final language = ref.watch(languageProvider).currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeSelector(context, ref, themeMode),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Language'),
          _buildLanguageSelector(context, ref, language),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, WidgetRef ref, ThemeMode currentTheme) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildThemeOption(
            context,
            ref,
            ThemeMode.system,
            'System',
            Icons.brightness_auto,
            currentTheme,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ref,
            ThemeMode.light,
            'Light',
            Icons.light_mode,
            currentTheme,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ref,
            ThemeMode.dark,
            'Dark',
            Icons.dark_mode,
            currentTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    String title,
    IconData icon,
    ThemeMode currentTheme,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Radio<ThemeMode>(
        value: mode,
        groupValue: currentTheme,
        onChanged: (ThemeMode? value) {
          if (value != null) {
            ref.read(themeProvider).themeMode = value;
          }
        },
      ),
      onTap: () {
        ref.read(themeProvider).themeMode = mode;
      },
    );
  }

  Widget _buildLanguageSelector(
      BuildContext context, WidgetRef ref, String currentLanguage) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            ref,
            LanguageState.ENGLISH,
            'English',
            'en',
            currentLanguage,
          ),
          const Divider(height: 1),
          _buildLanguageOption(
            context,
            ref,
            LanguageState.TIBETAN,
            'བོད་ཡིག', // Tibetan
            'bo་',
            currentLanguage,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String code,
    String title,
    String subtitle,
    String currentLanguage,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<String>(
        value: code,
        groupValue: currentLanguage,
        onChanged: (String? value) {
          if (value != null) {
            ref.read(languageProvider.notifier).setLanguage(value);
          }
        },
      ),
      onTap: () {
        ref.read(languageProvider.notifier).setLanguage(code);
      },
    );
  }
}
