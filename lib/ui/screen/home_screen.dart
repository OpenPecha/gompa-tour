import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/screen/festival_list_screen.dart';
import 'package:gompa_tour/ui/screen/organization_list_screen.dart';
import 'package:gompa_tour/util/enum.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            MenuType.deities,
            'assets/images/buddha.png',
            context,
          ),
          const SizedBox(height: 16),
          _buildCard(
            MenuType.organization,
            'assets/images/potala2.png',
            context,
          ),
          const SizedBox(height: 16),
          _buildCard(
            MenuType.festival,
            'assets/images/duchen.png',
            context,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCard(MenuType type, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case MenuType.deities:
            context.push(DeitiesListScreen.routeName);
            return;
          case MenuType.organization:
            context.push(OrganizationListScreen.routeName);
            return;
          case MenuType.festival:
            context.push(FestivalListScreen.routeName);
          default:
            break;
        }
      },
      child: Card(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 140,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                _getTitle(type, context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(MenuType type, BuildContext context) {
    switch (type) {
      case MenuType.deities:
        return AppLocalizations.of(context)!.deities;
      case MenuType.organization:
        return AppLocalizations.of(context)!.organizations;
      case MenuType.festival:
        return AppLocalizations.of(context)!.festival;
    }
  }
}
