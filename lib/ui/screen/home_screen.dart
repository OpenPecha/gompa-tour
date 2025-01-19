import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/ui/screen/deities_list_screen.dart';
import 'package:gompa_tour/ui/screen/festival_list_screen.dart';
import 'package:gompa_tour/ui/screen/orginatzations_screen.dart';
import 'package:gompa_tour/ui/screen/qr_screen.dart';
import 'package:gompa_tour/util/enum.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildHeader(context),
        _buildSearchBar(context),
        const Divider(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(8),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildCard(
                MenuType.deities,
                'assets/images/buddha.png',
                context,
              ),
              _buildCard(
                MenuType.organization,
                'assets/images/potala2.png',
                context,
              ),
              _buildCard(
                MenuType.pilgrimage,
                'assets/images/duchen.png',
                context,
              ),
              _buildCard(
                MenuType.festival,
                'assets/images/duchen.png',
                context,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Text(
          'Department of Religion and Culture',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Central Tibetan Administration',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ),
      child: SearchBar(
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Colors.white,
        ),
        controller: TextEditingController(),
        leading: Icon(Icons.search),
        trailing: [
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {},
          )
        ],
        hintText: 'Search here....',
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
            context.push(OrginatzationsScreen.routeName);
            return;
          case MenuType.festival:
            context.push(FestivalListScreen.routeName);
          default:
            break;
        }
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Image.asset(
                imagePath,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              _getTitle(type, context),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("199"),
            const SizedBox(height: 8),
          ],
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
      case MenuType.pilgrimage:
        return "Pilgrimage";
    }
  }
}
