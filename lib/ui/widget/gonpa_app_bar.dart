import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:gompa_tour/l10n/generated/app_localizations.dart';
import 'package:gompa_tour/states/language_state.dart';
import 'package:gompa_tour/states/theme_mode_state.dart';

class GonpaAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final double height; // Add height as a parameter for customization
  final List<Widget>? actions;
  final bool enableBackButton;
  final bool centerTitle;

  const GonpaAppBar({
    super.key,
    this.title,
    this.height = kToolbarHeight, // Default to AppBar's standard height
    this.actions,
    this.enableBackButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider).currentLanguage;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      leading: enableBackButton
          ? GestureDetector(
              onTap: context.pop,
              child: const Icon(Icons.arrow_back_ios),
            )
          : null,
      title: Text(
        AppLocalizations.of(context)!.neykor,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: currentLanguage == LanguageState.TIBETAN
              ? "TsumachuTibetan"
              : "Roboto",
        ),
      ),
      actions: [_buildActions(context, ref)],
      centerTitle: centerTitle,
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).themeMode;

    final currentLanguage = ref.watch(languageProvider).currentLanguage;

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
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
                ref.read(languageProvider.notifier).setLanguage(
                    val ? LanguageState.TIBETAN : LanguageState.ENGLISH);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
