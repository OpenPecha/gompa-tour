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
        _buildLegalSection(context),
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
              width: 55,
              height: 30,
              toggleSize: 20,
              valueFontSize: 12.0,
              value: currentLanguage == LanguageState.TIBETAN,
              activeText: "བོད་",
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

  Widget _buildLegalSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildSupportOption(
            context,
            AppLocalizations.of(context)!.privacyPolicy,
            Icons.privacy_tip_outlined,
            () => _showPrivacyPolicyDialog(context),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.privacyPolicy),
          content: SingleChildScrollView(
            child: Text(
              'Privacy Policy for GonpaTour\n\n'
              'Commitment to User Privacy\n\n'
              'GonpaTour is a informational app dedicated to sharing knowledge about Tibetan monasteries, statues, and festivals. We prioritize your privacy and transparency.\n\n'
              'App Characteristics:\n'
              '• No user account creation\n'
              '• No personal data collection\n'
              '• No tracking or analytics\n'
              '• Purely informational content\n'
              '• Offline-first approach\n\n'
              'Data Usage:\n'
              '• App content is pre-loaded and static\n'
              '• No user interactions are tracked\n'
              '• No personal information is stored or required\n'
              '• Content focuses solely on cultural education about Tibetan heritage\n\n'
              'Device Interaction:\n'
              '• Minimal app permissions\n'
              '• No access to personal device data\n'
              '• No location tracking\n'
              '• No internet connection required for most features\n\n'
              'Content Sourcing:\n'
              '• Cultural information curated from verified sources\n'
              '• Multimedia content (images, descriptions, audio) is pre-compiled\n'
              '• Respect for cultural authenticity and intellectual properties\n\n'
              'Security:\n'
              '• No data transmission\n'
              '• No user data storage\n'
              '• Completely privacy-focused design\n\n'
              'Updates:\n'
              '• Periodic content updates will not involve any user data\n'
              '• App updates focus on enriching cultural content\n\n'
              'By using GonpaTour, you agree to explore Tibetan cultural heritage with complete privacy and peace of mind.',
            ),
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
            AppLocalizations.of(context)!.system,
            Icons.brightness_auto,
            currentTheme,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ref,
            ThemeMode.light,
            AppLocalizations.of(context)!.light,
            Icons.light_mode,
            currentTheme,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            ref,
            ThemeMode.dark,
            AppLocalizations.of(context)!.dark,
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
      title: Text(
        title,
      ),
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
