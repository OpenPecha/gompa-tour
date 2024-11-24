import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gompa_tour/states/language_state.dart';
import 'package:gompa_tour/states/theme_mode_state.dart';

import 'config/go_router.dart';
import 'config/style.dart';
import 'helper/database_helper.dart';
import 'l10n/l10n.dart';
import 'l10n/localization_delegate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState currentTheme = ref.watch(themeProvider);
    final LanguageState currentLanguage = ref.watch(languageProvider);

    // Determine the font based on locale
    ThemeData currentLightTheme = Style.lightTheme;
    ThemeData currentDarkTheme = Style.darkTheme;

    // Check if the language is Tibetan
    if (currentLanguage.currentLanguage == 'bo') {
      currentLightTheme = Style.getTibetanTheme(baseTheme: Style.lightTheme);
      currentDarkTheme = Style.getTibetanTheme(baseTheme: Style.darkTheme);
    }

    return MaterialApp.router(
      title: 'Gompa Tour',
      locale: Locale(currentLanguage.currentLanguage),
      theme: currentLightTheme,
      darkTheme: currentDarkTheme,
      themeMode: currentTheme.themeMode,
      localizationsDelegates: [
        MaterialLocalizationTbDelegate(),
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
