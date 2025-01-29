import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        _buildSupportSection(context),
        _buildAboutAppSection(context),
        _buildAboutUsSection(context),
        _buildPrayerAppSection(context),
        _buildShareAppSection(context),
      ],
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

  Widget _buildAboutAppSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildAboutAppOption(
            context,
            AppLocalizations.of(context)!.aboutApp,
            () => _showAboutAppDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutUsSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildAboutUsOption(
            context,
            AppLocalizations.of(context)!.aboutUs,
            () => _showAboutUsDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerAppSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildPrayerAppOption(
            context,
            AppLocalizations.of(context)!.prayerApp,
            () => _showPrayerAppDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShareAppSection(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildShareAppOption(
            context,
            AppLocalizations.of(context)!.shareApp,
            () => _showAboutUsDialog(context),
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

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.contactSupport),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Gompa Tour"),
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

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.aboutUs),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "The Department of Religion and Culture is a ministry office established under the executive organ of Central Tibetan Administration whose function is to overlook religious and cultural affairs in Tibetan exile community. It has the responsibility of supervising works aimed at reviving, preserving, and promotion of Tibetan religious and cultural heritage that is being led to the verge of extinction in Tibet."),
                const Text(
                    "It began its operation in exile community as Council for Religious Affairs office on April 27, 1959, headed by a Director and constituted by the representative of the four Buddhist schools as its principal members in Mussorrie. On 30th May 1960, the Council for Religious Affairs shifted its office to Dharamsala and on September 12, 1960, it became one of the seven main departments when His Holiness the Dalai Lama formally established the Central Tibetan Administration (CTA)."),
                const Text(
                    "Under the affiliation of this department, there are 255 monasteries and 37 nunneries in India, Nepal and Bhutan and also five cultural institutions across India"),
              ],
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

  void _showPrayerAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.prayerApp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "This prayer app is developed by the Dept of Religion and Culture of Central Tibetan Administration to make availability of the Tibetan prayers in digital format."),
              const Text(
                  "The app consist of daily prayers, prayers of different Tibetan Buddhist schools, mantras and official prayers books. "),
              const Text(
                  "It also has a facility of listening short daily prayers and mantras in audio."),
              const Text(
                  "Apart from prayers, this app  contains a list and description of holy Buddhist pilgrimage sites and festivals of Tibet."),
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
      leading: Icon(Icons.phone),
      title: Text(title),
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

Widget _buildAboutAppOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  return ListTile(
    leading: Image.asset(
        'assets/images/logo.png'), // Replace with your app logo path
    title: Text(title),
    onTap: onTap,
    trailing: const Icon(Icons.chevron_right),
  );
}

Widget _buildAboutUsOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  return ListTile(
    leading: Image.asset(
        'assets/images/logo.png'), // Replace with your app logo path
    title: Text(title),
    onTap: onTap,
    trailing: const Icon(Icons.chevron_right),
  );
}

Widget _buildPrayerAppOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  return ListTile(
    leading: Image.asset(
        'assets/images/logo.png'), // Replace with your app logo path
    title: Text(title),
    onTap: onTap,
    trailing: const Icon(Icons.chevron_right),
  );
}

Widget _buildShareAppOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  return ListTile(
    leading: Icon(Icons.share), // Replace with your app logo path
    title: Text(title),
    onTap: onTap,
    trailing: const Icon(Icons.chevron_right),
  );
}
