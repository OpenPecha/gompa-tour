import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/style.dart';
import '../../states/bottom_nav_state.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? navIndex = ref.watch(bottomNavProvider) as int?;

    return Card(
      margin: const EdgeInsets.all(0),
      elevation: Theme.of(context).bottomNavigationBarTheme.elevation,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Style.radiusLg,
          topRight: Style.radiusLg,
        ),
        side: BorderSide(
          color: Theme.of(context).shadowColor,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: navIndex ?? 1,
        onTap: (int index) {
          ref.read(bottomNavProvider.notifier).setAndPersistValue(index);
        },
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home), //bot_20_regular
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: AppLocalizations.of(context)!.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code),
            label: AppLocalizations.of(context)!.qr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppLocalizations.of(context)!.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
