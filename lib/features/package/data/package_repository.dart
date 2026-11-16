import '../../../../common/network/load_exception.dart';
import '../domain/i_package_repository.dart';
import '../domain/package_page.dart';
import '../domain/php_package.dart';
import 'data_sources/i_package_data_source.dart';
import 'dto/package_detail_dto.dart';
import 'dto/package_search_dto.dart';
import 'mappers/package_mapper.dart';

/// Каталог PHP-пакетов из сети Packagist.
class PackageRepository implements IPackageRepository {
  const PackageRepository(this._dataSource);

  final IPackageDataSource _dataSource;

  /// Packagist не отдаёт каталог без поискового запроса
  /// (400 «Missing search query»), поэтому пустой запрос заменяем
  /// на широкий: почти все пакеты упоминают PHP.
  static const _defaultQuery = 'php';

  @override
  Future<PackagePage> search(String query, {int page = 1}) async {
    final trimmed = query.trim();
    final effective = trimmed.isEmpty ? _defaultQuery : trimmed;

    final dto = await _dataSource.search(effective, page: page);
    return PackagePage(
      packages: [for (final item in dto.results) item.toModel()],
      total: dto.total,
      hasMore: dto.next != null,
    );
  }

  @override
  Future<PhpPackage?> getByName(String name) async {
    // Метаданные пакета и его счётчики лежат в разных ответах:
    // версии на repo.packagist.org, счётчики в выдаче поиска.
    // Оба запроса отправляем параллельно.
    final results = await Future.wait<Object?>([
      () async {
        try {
          return await _dataSource.getPackage(name);
        } on LoadClientException catch (exception) {
          // 404 — это «пакета нет», а не ошибка загрузки.
          if (exception.statusCode == 404) return null;
          rethrow;
        }
      }(),
      () async {
        try {
          return await _dataSource.search(name);
        } on LoadException {
          // Счётчики не критичны: без них пакет всё равно показываем.
          return null;
        }
      }(),
    ]);

    final detail = results[0] as PackageDetailResponseDto?;
    if (detail == null) return null;

    final summary = _exactMatch(results[1] as PackageSearchResponseDto?, name);
    return detail.toModel(name, summary: summary);
  }

  @override
  Future<bool> exists(String name) async {
    final dto = await _dataSource.search(name);
    return dto.results.any((item) => item.name == name);
  }

  /// Ищет пакет в выдаче по точному совпадению имени.
  static PackageSummaryDto? _exactMatch(
    PackageSearchResponseDto? results,
    String name,
  ) {
    if (results == null) return null;
    for (final item in results.results) {
      if (item.name == name) return item;
    }
    return null;
  }
}
