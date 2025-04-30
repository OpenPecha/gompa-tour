import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bo.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bo'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Neykor'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get qr;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search here...'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Search'**
  String get recentSearches;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @deities.
  ///
  /// In en, this message translates to:
  /// **'Statues'**
  String get deities;

  /// No description provided for @organizations.
  ///
  /// In en, this message translates to:
  /// **'Monasteries'**
  String get organizations;

  /// No description provided for @festival.
  ///
  /// In en, this message translates to:
  /// **'Festivals'**
  String get festival;

  /// No description provided for @deity.
  ///
  /// In en, this message translates to:
  /// **'Deity'**
  String get deity;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Monastery'**
  String get organization;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @noRecordFound.
  ///
  /// In en, this message translates to:
  /// **'No Record Found'**
  String get noRecordFound;

  /// No description provided for @noRecentSearch.
  ///
  /// In en, this message translates to:
  /// **'No Recent Search'**
  String get noRecentSearch;

  /// No description provided for @buddha.
  ///
  /// In en, this message translates to:
  /// **'Buddha'**
  String get buddha;

  /// No description provided for @king.
  ///
  /// In en, this message translates to:
  /// **'King'**
  String get king;

  /// No description provided for @gaden.
  ///
  /// In en, this message translates to:
  /// **'Gaden'**
  String get gaden;

  /// No description provided for @arya.
  ///
  /// In en, this message translates to:
  /// **'Arya'**
  String get arya;

  /// No description provided for @acharya.
  ///
  /// In en, this message translates to:
  /// **'Acharya'**
  String get acharya;

  /// No description provided for @milarepa.
  ///
  /// In en, this message translates to:
  /// **'Milarepa'**
  String get milarepa;

  /// No description provided for @india.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get india;

  /// No description provided for @nepal.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get nepal;

  /// No description provided for @bhutan.
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get bhutan;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About This App'**
  String get aboutApp;

  /// No description provided for @prayerApp.
  ///
  /// In en, this message translates to:
  /// **'Tibetan Prayer App'**
  String get prayerApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @nyingma.
  ///
  /// In en, this message translates to:
  /// **'Nyingma'**
  String get nyingma;

  /// No description provided for @kagyu.
  ///
  /// In en, this message translates to:
  /// **'Kagyu'**
  String get kagyu;

  /// No description provided for @sakya.
  ///
  /// In en, this message translates to:
  /// **'Sakya'**
  String get sakya;

  /// No description provided for @gelug.
  ///
  /// In en, this message translates to:
  /// **'Gelug'**
  String get gelug;

  /// No description provided for @bon.
  ///
  /// In en, this message translates to:
  /// **'Bon'**
  String get bon;

  /// No description provided for @jonang.
  ///
  /// In en, this message translates to:
  /// **'Jonang'**
  String get jonang;

  /// No description provided for @remey.
  ///
  /// In en, this message translates to:
  /// **'Remey'**
  String get remey;

  /// No description provided for @shalu.
  ///
  /// In en, this message translates to:
  /// **'Shalu'**
  String get shalu;

  /// No description provided for @bodong.
  ///
  /// In en, this message translates to:
  /// **'Bodong'**
  String get bodong;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @allGonpa.
  ///
  /// In en, this message translates to:
  /// **'All Gonpa'**
  String get allGonpa;

  /// No description provided for @pilgrimage.
  ///
  /// In en, this message translates to:
  /// **'Pilgrimages'**
  String get pilgrimage;

  /// No description provided for @neykor.
  ///
  /// In en, this message translates to:
  /// **'Neykor'**
  String get neykor;

  /// No description provided for @deptName.
  ///
  /// In en, this message translates to:
  /// **'Department of Religion and Culture'**
  String get deptName;

  /// No description provided for @downloadApp.
  ///
  /// In en, this message translates to:
  /// **'Download The App'**
  String get downloadApp;

  /// No description provided for @gonpaTypes.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get gonpaTypes;

  /// No description provided for @allStates.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get allStates;

  /// No description provided for @deptDescription.
  ///
  /// In en, this message translates to:
  /// **'The Department of Religion and Culture is a ministry office established under the executive organ of Central Tibetan Administration whose function is to overlook religious and cultural affairs in Tibetan exile community. It has the responsibility of supervising works aimed at reviving, preserving, and promotion of Tibetan religious and cultural heritage that is being led to the verge of extinction in Tibet.\nIt began its operation in exile community as Council for Religious Affairs office on April 27, 1959, headed by a Director and constituted by the representative of the four Buddhist schools as its principal members in Mussorrie. On 30th May 1960, the Council for Religious Affairs shifted its office to Dharamsala and on September 12, 1960, it became one of the seven main departments when His Holiness the Dalai Lama formally established the Central Tibetan Administration (CTA).\nUnder the affiliation of this department, there are 255 monasteries and 37 nunneries in India, Nepal and Bhutan and also five cultural institutions across India'**
  String get deptDescription;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'In 1959, Tibet experienced a major upheaval that resulted in the destruction of over 6,000 monasteries and priceless historical documents. Despite this devastating period, the Tibetan community in exile, led by His Holiness the Dalai Lama and other religious leaders, has worked tirelessly over the past 65 years to rebuild and preserve Tibetan cultural heritage.\nWith economic and living standards improving globally, tourism has been steadily increasing across various regions. Pilgrims and travelers visiting Tibetan settlements now include not just Tibetans, but also Himalayan Buddhists, Indians and numerous international visitors. In response to this growing interest, the Department of Religion and Culture of the Central Tibetan Administration has developed a mobile application that provides a useful guide for visitors to Tibetan monasteries and sacred Buddhist sites. This Neykor application serves as an innovative educational tool, allowing diverse groups of visitors to gain meaningful insights into the rich background of Tibetan monasteries and their significant religious artifacts, thereby promoting cultural awareness and appreciation.\nThrough this mobile app, travelers can learn about Tibetan monasteries, sacred artifacts, Buddhist sites and important Tibetan festivals. The application helps visitors understand the value of Tibetan culture and religion, particularly targeting young Tibetans and Himalayan Buddhists. We hope that this application will provide meaningful information about the Tibetan monasteries and its sacred statues and religious artifacts for the users.'**
  String get aboutAppDescription;

  /// No description provided for @prayerAppDescription.
  ///
  /// In en, this message translates to:
  /// **'This prayer app is developed by the Dept of Religion and Culture of Central Tibetan Administration to make availability of the Tibetan prayers in digital format.\n The app consist of daily prayers, prayers of different Tibetan Buddhist schools, mantras and official prayers books.\n It also has a facility of listening short daily prayers and mantras in audio.\n Apart from prayers, this app  contains a list and description of holy Buddhist pilgrimage sites and festivals of Tibet.'**
  String get prayerAppDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bo', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bo': return AppLocalizationsBo();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
