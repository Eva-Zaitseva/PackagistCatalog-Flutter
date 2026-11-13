import 'php_package.dart';

/// Источник данных каталога PHP-пакетов.
///
/// В ЛР2 данные берутся из моков; в ЛР3 вместо моков будет сеть,
/// и изменится только реализация в слое data.
abstract interface class IPackageRepository {
  /// Все пакеты каталога.
  Future<List<PhpPackage>> getAll();

  /// Пакет по полному имени `vendor/project` или `null`, если его нет.
  Future<PhpPackage?> getByName(String name);
}
