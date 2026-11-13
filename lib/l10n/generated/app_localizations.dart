import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @catalog_title.
  ///
  /// In ru, this message translates to:
  /// **'Каталог PHP-пакетов'**
  String get catalog_title;

  /// No description provided for @search_packages.
  ///
  /// In ru, this message translates to:
  /// **'Поиск пакетов'**
  String get search_packages;

  /// No description provided for @search_hint.
  ///
  /// In ru, this message translates to:
  /// **'Например, laravel'**
  String get search_hint;

  /// No description provided for @package_count.
  ///
  /// In ru, this message translates to:
  /// **'Найдено пакетов: {count}'**
  String package_count(int count);

  /// No description provided for @version.
  ///
  /// In ru, this message translates to:
  /// **'Версия: {version}'**
  String version(String version);

  /// No description provided for @downloads.
  ///
  /// In ru, this message translates to:
  /// **'Загрузки: {downloads}'**
  String downloads(String downloads);

  /// No description provided for @stars.
  ///
  /// In ru, this message translates to:
  /// **'Звёзды: {stars}'**
  String stars(int stars);

  /// No description provided for @package_information.
  ///
  /// In ru, this message translates to:
  /// **'Информация о пакете'**
  String get package_information;

  /// No description provided for @dependencies_title.
  ///
  /// In ru, this message translates to:
  /// **'Зависимости (require)'**
  String get dependencies_title;

  /// No description provided for @no_dependencies.
  ///
  /// In ru, this message translates to:
  /// **'У этого пакета нет указанных зависимостей.'**
  String get no_dependencies;

  /// No description provided for @open_package.
  ///
  /// In ru, this message translates to:
  /// **'Открыть пакет'**
  String get open_package;

  /// No description provided for @package_not_found.
  ///
  /// In ru, this message translates to:
  /// **'Нет в тестовом каталоге'**
  String get package_not_found;

  /// No description provided for @detail_not_found.
  ///
  /// In ru, this message translates to:
  /// **'Пакет не найден в каталоге'**
  String get detail_not_found;

  /// No description provided for @nothing_found_title.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get nothing_found_title;

  /// No description provided for @nothing_found_subtitle.
  ///
  /// In ru, this message translates to:
  /// **'По запросу «{query}» нет ни одного пакета. Попробуйте изменить запрос.'**
  String nothing_found_subtitle(String query);

  /// No description provided for @theme_setting.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme_setting;

  /// No description provided for @theme_system.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get theme_system;

  /// No description provided for @theme_light.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get theme_dark;

  /// No description provided for @language_setting.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language_setting;

  /// No description provided for @language_system.
  ///
  /// In ru, this message translates to:
  /// **'Системный'**
  String get language_system;

  /// No description provided for @language_russian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get language_russian;

  /// No description provided for @language_english.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get language_english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
