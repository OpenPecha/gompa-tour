import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../states/language_state.dart';
import '../../states/theme_mode_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).themeMode;
    final language = ref.watch(languageProvider).currentLanguage;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        _buildThemeToggle(context, ref, themeMode),
        _buildLanguageToggle(context, ref, language),
        _buildSupportSection(context),
      ],
    );
  }

  Widget _buildThemeToggle(
      BuildContext context, WidgetRef ref, ThemeMode currentTheme) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.theme,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            FlutterSwitch(
              width: 55,
              height: 30,
              toggleSize: 20,
              value: currentTheme == ThemeMode.dark,
              activeIcon: Icon(Icons.dark_mode, size: 15),
              inactiveIcon: Icon(Icons.light_mode, size: 15),
              onToggle: (val) {
                ref.read(themeProvider).themeMode =
                    val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(
      BuildContext context, WidgetRef ref, String currentLanguage) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            FlutterSwitch(
              width: 60,
              height: 30,
              toggleSize: 20,
              valueFontSize: 12.0,
              value: currentLanguage == LanguageState.TIBETAN,
              activeText: "བོད།",
              inactiveText: "EN",
              showOnOff: true,
              onToggle: (val) {
                ref.read(languageProvider.notifier).setLanguage(
                    val ? LanguageState.TIBETAN : LanguageState.ENGLISH);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildSupportOption(
            context,
            AppLocalizations.of(context)!.contactUs,
            Icons.contact_support,
            () => _showContactDialog(context),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.contactSupport),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Central Tibetan Administration"),
              const Text("Gangchen Kyishong, Dharamshala"),
              const Text("Kangra District, HP 176215, India"),
              const Text("Tel: +91-1892-222685, 226737"),
              const Text('Fax: +91-1892-228037'),
              const Text('Email: religion@tibet.net'),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupportOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
