import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/ui/screen/qr_screen.dart';
import 'package:gompa_tour/ui/screen/search_screen.dart';
import 'package:gompa_tour/ui/screen/settings_screen.dart';

import '../../states/bottom_nav_state.dart';
import '../widget/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class SkeletonScreen extends ConsumerWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? navIndex = ref.watch(bottomNavProvider) as int?;

    // Tab configuration
    List<Map<String, dynamic>> tabConfigurations = _tabConfiguration(context);
    final currentTab = tabConfigurations[navIndex ?? 1];
    const List<Widget> pageNavigation = <Widget>[
      HomeScreen(),
      MapScreen(),
      QrScreen(),
      SearchScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: currentTab['title'] != null
          ? AppBar(
              title: currentTab['title'] == "home"
                  ? Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                    )
                  : Text(currentTab['title']),
              centerTitle: true,
              elevation: 1,
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pageNavigation.elementAt(navIndex ?? 1),
      ),
      bottomNavigationBar: const BottomNavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  List<Map<String, dynamic>> _tabConfiguration(BuildContext context) {
    return [
      {
        'title': "home",
        'icon': Icons.home,
        'screen': const HomeScreen(),
      },
      {
        'title': "",
        'icon': Icons.map,
        'screen': const MapScreen(),
      },
      {
        'title': "",
        'icon': Icons.qr_code_scanner,
        'screen': const QrScreen(),
      },
      {
        'title': '',
        'icon': Icons.search,
        'screen': const SearchScreen(),
      },
      {
        'title': AppLocalizations.of(context)!.settings,
        'icon': Icons.settings,
        'screen': const SettingsScreen(),
      },
    ];
  }
}
