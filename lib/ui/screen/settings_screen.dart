import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Support'),
          _buildSupportSection(context),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Legal'),
          _buildLegalSection(context),
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

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildSupportOption(
            context,
            'FAQ',
            Icons.help_outline,
            () => _showFAQDialog(context),
          ),
          const Divider(height: 1),
          _buildSupportOption(
            context,
            'Contact Us',
            Icons.contact_support,
            () => _showContactDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
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
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            () => _showPrivacyPolicyDialog(context),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Frequently Asked Questions'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Q1: How do I reset my password?'),
                Text(
                    'A1: Navigate to the login screen and tap "Forgot Password".'),
                SizedBox(height: 16),
                Text('Q2: How can I update my profile?'),
                Text('A2: Go to Profile Settings in the main menu.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
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
              ElevatedButton(
                onPressed: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'religion@tibet.net',
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  }
                },
                child: const Text('Send Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'We respect your privacy and are committed to protecting your personal data. '
              'This Privacy Policy explains how we collect, use, and safeguard your information.',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
