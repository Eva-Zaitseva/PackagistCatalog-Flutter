import 'package_page.dart';
import 'php_package.dart';

/// Источник данных каталога PHP-пакетов.
///
/// Реализация в слое data ходит в сеть Packagist; слои выше знают
/// только этот интерфейс.
abstract interface class IPackageRepository {
  /// Страница выдачи поиска по имени и описанию пакета.
  ///
  /// Пустой запрос означает весь каталог: реализация сама решает,
  /// какой запрос отправить API. Нумерация страниц с единицы.
  Future<PackagePage> search(String query, {int page});

  /// Полные данные пакета по имени `vendor/project`
  /// или `null`, если пакета нет.
  Future<PhpPackage?> getByName(String name);

  /// Есть ли пакет с таким именем в каталоге.
  ///
  /// Нужен для проверки связанных записей: зависимость из `require`
  /// может и существовать, и нет.
  Future<bool> exists(String name);
}
