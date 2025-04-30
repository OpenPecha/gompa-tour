import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
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
          leading: Image.asset('assets/images/cta_logo.png', width: 40),
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
          leading: Image.asset('assets/images/app_logo.png', width: 40),
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
            // open the app store link
            final String shareUrl =
                Platform.isIOS ? kIosNeykorAppUrl : kAndriodNeykorAppUrl;
            Share.share(shareUrl);
          },
        ),
      ),
    ];
  }

  void _showDialog(BuildContext context, DialogContent content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
        return "";
      case DialogContent.aboutApp:
        return AppLocalizations.of(context)!.aboutApp;
      case DialogContent.aboutUs:
        return AppLocalizations.of(context)!.aboutUs;
      case DialogContent.prayerApp:
        return AppLocalizations.of(context)!.prayerApp;
    }
  }

  // Add this method in the class:
  List<Widget> _buildContactItems(
      BuildContext context, List<(String, String?)> items) {
    Locale locale = Localizations.localeOf(context);

    return items
        .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: item.$2 != null
                  ? InkWell(
                      onTap: () => _launchUrl(item.$2!),
                      child: Text(
                        item.$1,
                        style: TextStyle(
                          fontSize: locale.languageCode == 'bo' ? 14 : 16,
                          height: locale.languageCode == 'bo' ? 1.8 : 1.5,

                          color: Theme.of(context).colorScheme.primary,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(item.$1,
                      style: TextStyle(
                        fontSize: locale.languageCode == 'bo' ? 14 : 16,
                        height: locale.languageCode == 'bo' ? 1.8 : 1.5,
                      )),
            ))
        .toList();
  }

  List<Widget> _getDialogContent(DialogContent content, BuildContext context) {
    const spacing = SizedBox(height: 16);
    Locale locale = Localizations.localeOf(context);

    switch (content) {
      case DialogContent.contact:
        return [
          ..._buildContactItems(context, [
            ('Central Tibetan Administration', null),
            ('Gangchen Kyishong, Dharamshala', null),
            ('Kangra District, HP 176215, India', null),
            ('Tel: +91-1892-222685, 226737', 'Tel:+91-1892-222685'),
            ('Fax: +91-1892-228037', null),
            ('Email: religion@tibet.net', 'mailto:religion@tibet.net'),
          ]),

          // spacing,
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
          Text(
            AppLocalizations.of(context)!.prayerAppDescription,
            style: TextStyle(
              fontSize: 16,
              height: locale.languageCode == 'bo' ? 2 : 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // add a download link based on the platform
          Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.downloadApp,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // open the app store link
                  final String downloadUrl = Platform.isIOS
                      ? kIosTibetanPrayerAppUrl
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
