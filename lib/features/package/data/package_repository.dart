import '../domain/i_package_repository.dart';
import '../domain/php_package.dart';
import 'mock_packages.dart';

/// Каталог на демонстрационных моках.
///
/// В ЛР3 здесь появится сетевая реализация, интерфейс не изменится.
class PackageRepository implements IPackageRepository {
  const PackageRepository();

  @override
  Future<List<PhpPackage>> getAll() async => MockPackages.packages;

  @override
  Future<PhpPackage?> getByName(String name) async {
    for (final package in MockPackages.packages) {
      if (package.name == name) return package;
    }
    return null;
  }
}
