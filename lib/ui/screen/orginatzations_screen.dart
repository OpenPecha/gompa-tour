import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/ui/screen/organization_list_screen.dart';
import 'package:gompa_tour/ui/widget/gonpa_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrginatzationsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/organizations-screen';

  const OrginatzationsScreen({super.key});

  @override
  ConsumerState<OrginatzationsScreen> createState() =>
      _OrginatzationsScreenState();
}

class _OrginatzationsScreenState extends ConsumerState<OrginatzationsScreen> {
  // list of organizations
  final organizations = [
    {"CHA0": "Nyingma"},
    {"CHB0": "Kagyu"},
    {"CHC0": "Sakya"},
    {"CHD0": "Gelug"},
    {"CHE0": "Bon"},
    {"CHF0": "Jonang"},
    {"CHG": "Others"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GonpaAppBar(title: ''),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          final organization = organizations[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the detail screen of the item
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrganizationListScreen(
                    category: organization.keys.first,
                  ),
                ),
              );
            },
            child: Card(
              shadowColor: Theme.of(context).colorScheme.shadow,
              color: Theme.of(context).colorScheme.surfaceContainer,
              margin: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Text(
                  _getTitle(organization.values.first, context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // height: context.getLocalizedHeight(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTitle(String category, BuildContext context) {
    switch (category) {
      case "Nyingma":
        return AppLocalizations.of(context)!.nyingma;
      case "Kagyu":
        return AppLocalizations.of(context)!.kagyu;
      case "Sakya":
        return AppLocalizations.of(context)!.sakya;
      case "Gelug":
        return AppLocalizations.of(context)!.gelug;
      case "Bon":
        return AppLocalizations.of(context)!.bon;
      case "Jonang":
        return AppLocalizations.of(context)!.jonang;
      case "Others":
        return AppLocalizations.of(context)!.others;
      default:
        return "";
    }
  }
}
