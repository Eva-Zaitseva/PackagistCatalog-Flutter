// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get catalog_title => 'Каталог PHP-пакетов';

  @override
  String get search_packages => 'Поиск пакетов';

  @override
  String get search_hint => 'Например, laravel';

  @override
  String package_count(int count) {
    return 'Найдено пакетов: $count';
  }

  @override
  String version(String version) {
    return 'Версия: $version';
  }

  @override
  String downloads(String downloads) {
    return 'Загрузки: $downloads';
  }

  @override
  String stars(int stars) {
    return 'Звёзды: $stars';
  }

  @override
  String get package_information => 'Информация о пакете';

  @override
  String get dependencies_title => 'Зависимости (require)';

  @override
  String get no_dependencies => 'У этого пакета нет указанных зависимостей.';

  @override
  String get open_package => 'Открыть пакет';

  @override
  String get package_not_found => 'Нет в тестовом каталоге';

  @override
  String get detail_not_found => 'Пакет не найден в каталоге';

  @override
  String get page_not_found => 'Такой страницы нет';

  @override
  String get nothing_found_title => 'Ничего не найдено';

  @override
  String nothing_found_subtitle(String query) {
    return 'По запросу «$query» нет ни одного пакета. Попробуйте изменить запрос.';
  }

  @override
  String get theme_setting => 'Тема';

  @override
  String get theme_system => 'Системная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get language_setting => 'Язык';

  @override
  String get language_system => 'Системный';

  @override
  String get language_russian => 'Русский';

  @override
  String get language_english => 'Английский';
}
