import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gompa_tour/states/language_state.dart';
import 'package:gompa_tour/states/theme_mode_state.dart';
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
    final currentLanguage = ref.watch(languageProvider).currentLanguage;

    // Tab configuration
    List<Map<String, dynamic>> tabConfigurations = _tabConfiguration(context);
    final currentTab = tabConfigurations[navIndex ?? 1];
    const List<Widget> pageNavigation = <Widget>[
      HomeScreen(),
      MapScreen(),
      QrScreen(),
      SettingsScreen(),
    ];

    final themeMode = ref.watch(themeProvider).themeMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.neykor,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        elevation: 1,
        actions: [
          currentTab["title"] == "home"
              ? FlutterSwitch(
                  width: 60,
                  height: 30,
                  toggleSize: 20,
                  valueFontSize:
                      currentLanguage == LanguageState.ENGLISH ? 16.0 : 12.0,
                  value: currentLanguage == LanguageState.TIBETAN,
                  activeText: "EN",
                  inactiveText: "བོད།",
                  showOnOff: true,
                  onToggle: (val) {
                    ref.read(languageProvider.notifier).setLanguage(
                        val ? LanguageState.TIBETAN : LanguageState.ENGLISH);
                  },
                )
              : const SizedBox(),
          MenuAnchor(
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'Show menu',
                );
              },
              style: MenuStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.all(12.0),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(Size(190, 48))),
              menuChildren: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.theme,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(width: 20),
                    FlutterSwitch(
                      width: 55,
                      height: 30,
                      toggleSize: 20,
                      value: themeMode == ThemeMode.dark,
                      activeIcon: Icon(Icons.dark_mode, size: 15),
                      inactiveIcon: Icon(Icons.light_mode, size: 15),
                      onToggle: (val) {
                        ref.read(themeProvider).themeMode =
                            val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.language,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(width: 20),
                    FlutterSwitch(
                      width: 55,
                      height: 30,
                      toggleSize: 20,
                      valueFontSize: 12.0,
                      value: currentLanguage == LanguageState.TIBETAN,
                      activeText: "བོད།",
                      inactiveText: "EN",
                      showOnOff: true,
                      onToggle: (val) {
                        ref.read(languageProvider.notifier).setLanguage(val
                            ? LanguageState.TIBETAN
                            : LanguageState.ENGLISH);
                      },
                    ),
                  ],
                ),
              ]),
        ],
      ),
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
        'title': "map",
        'icon': Icons.map,
        'screen': const MapScreen(),
      },
      {
        'title': "qr",
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
