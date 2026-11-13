// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get catalog_title => 'PHP Packages Catalog';

  @override
  String get search_packages => 'Search packages';

  @override
  String get search_hint => 'For example, laravel';

  @override
  String package_count(int count) {
    return 'Packages found: $count';
  }

  @override
  String version(String version) {
    return 'Version: $version';
  }

  @override
  String downloads(String downloads) {
    return 'Downloads: $downloads';
  }

  @override
  String stars(int stars) {
    return 'Stars: $stars';
  }

  @override
  String get package_information => 'Package information';

  @override
  String get dependencies_title => 'Dependencies (require)';

  @override
  String get no_dependencies => 'This package has no listed dependencies.';

  @override
  String get open_package => 'Open package';

  @override
  String get package_not_found => 'Not in the test catalog';

  @override
  String get detail_not_found => 'Package not found in the catalog';

  @override
  String get nothing_found_title => 'Nothing found';

  @override
  String nothing_found_subtitle(String query) {
    return 'No packages match \"$query\". Try a different query.';
  }

  @override
  String get theme_setting => 'Theme';

  @override
  String get theme_system => 'System';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get language_setting => 'Language';

  @override
  String get language_system => 'System';

  @override
  String get language_russian => 'Russian';

  @override
  String get language_english => 'English';
}
