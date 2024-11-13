import 'package:flutter/material.dart';
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
    const List<Widget> pageNavigation = <Widget>[
      HomeScreen(),
      MapScreen(),
      QrScreen(),
      SearchScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Gompa Tour'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pageNavigation.elementAt(navIndex ?? 1),
      ),
      bottomNavigationBar: const BottomNavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
