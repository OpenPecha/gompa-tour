import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/config/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 16),
        ...buildSettingsSections(context),
      ],
    );
  }

  List<Widget> buildSettingsSections(BuildContext context) {
    return [
      SettingsCard(
        child: SettingsListTile(
          leading: Image.asset('assets/images/cta.jpg', width: 40),
          title: AppLocalizations.of(context)!.aboutUs,
          onTap: () => _showDialog(
            context,
            DialogContent.aboutUs,
          ),
        ),
      ),
      SettingsCard(
        child: SettingsListTile(
          leading: const Icon(Icons.phone),
          title: AppLocalizations.of(context)!.contactUs,
          onTap: () => _showDialog(
            context,
            DialogContent.contact,
          ),
        ),
      ),
      SettingsCard(
        child: SettingsListTile(
          leading: Image.asset('assets/images/logo.png', width: 40),
          title: AppLocalizations.of(context)!.aboutApp,
          onTap: () => _showDialog(
            context,
            DialogContent.aboutApp,
          ),
        ),
      ),
      SettingsCard(
        child: SettingsListTile(
          leading: Image.asset('assets/images/religion.png', width: 40),
          title: AppLocalizations.of(context)!.prayerApp,
          onTap: () => _showDialog(
            context,
            DialogContent.prayerApp,
          ),
        ),
      ),
      SettingsCard(
        child: SettingsListTile(
          leading: const Icon(Icons.share),
          title: AppLocalizations.of(context)!.shareApp,
          onTap: () {
            Share.share(
                "https://play.google.com/store/apps/details?id=com.chorig.tibetanprayer");
          },
        ),
      ),
    ];
  }

  void _showDialog(BuildContext context, DialogContent content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getDialogTitle(context, content)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getDialogContent(content, context),
          ),
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  String _getDialogTitle(BuildContext context, DialogContent content) {
    switch (content) {
      case DialogContent.contact:
        return AppLocalizations.of(context)!.contactSupport;
      case DialogContent.aboutApp:
        return AppLocalizations.of(context)!.aboutApp;
      case DialogContent.aboutUs:
        return AppLocalizations.of(context)!.aboutUs;
      case DialogContent.prayerApp:
        return AppLocalizations.of(context)!.prayerApp;
    }
  }

  List<Widget> _getDialogContent(DialogContent content, BuildContext context) {
    const spacing = SizedBox(height: 16);
    Locale locale = Localizations.localeOf(context);

    switch (content) {
      case DialogContent.contact:
        return [
          const Text("Central Tibetan Administration"),
          const Text("Gangchen Kyishong, Dharamshala"),
          const Text("Kangra District, HP 176215, India"),
          const Text("Tel: +91-1892-222685, 226737"),
          const Text('Fax: +91-1892-228037'),
          const Text('Email: religion@tibet.net'),
          spacing,
        ];
      case DialogContent.aboutApp:
        return [
          Text(
            AppLocalizations.of(context)!.aboutAppDescription,
            style: TextStyle(
              fontSize: 16,
              height: locale.languageCode == 'bo' ? 2 : 1.5,
            ),
          ),
          spacing,
        ];
      case DialogContent.aboutUs:
        return [
          Text(
            AppLocalizations.of(context)!.deptDescription,
            style: TextStyle(
              fontSize: 16,
              height: locale.languageCode == 'bo' ? 2 : 1.5,
            ),
          ),
          spacing,
        ];
      case DialogContent.prayerApp:
        return [
          const Text(
              "This prayer app is developed by the Dept of Religion and Culture of Central Tibetan Administration to make availability of the Tibetan prayers in digital format."),
          const Text(
              "The app consist of daily prayers, prayers of different Tibetan Buddhist schools, mantras and official prayers books. "),
          const Text(
              "It also has a facility of listening short daily prayers and mantras in audio."),
          const Text(
              "Apart from prayers, this app  contains a list and description of holy Buddhist pilgrimage sites and festivals of Tibet."),
          const SizedBox(height: 12),
          // add a download link based on the platform
          Text.rich(
            TextSpan(
              text: "Download the app",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // open the app store link
                  final String downloadUrl = Platform.isIOS
                      ? KIosTibetanPrayerAppUrl
                      : kAndriodTibetanPrayerAppUrl;
                  _launchUrl(downloadUrl);
                },
            ),
          ),
          spacing,
        ];
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

enum DialogContent { contact, aboutApp, aboutUs, prayerApp }

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(children: [child]),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
