import '../dto/package_detail_dto.dart';
import '../dto/package_search_dto.dart';

/// Источник данных каталога: умеет искать пакеты и получать метаданные.
abstract interface class IPackageDataSource {
  /// Страница выдачи поиска; нумерация страниц с единицы.
  Future<PackageSearchResponseDto> search(String query, {int page});

  /// Все версии пакета по имени `vendor/project`.
  Future<PackageDetailResponseDto> getPackage(String name);
}
