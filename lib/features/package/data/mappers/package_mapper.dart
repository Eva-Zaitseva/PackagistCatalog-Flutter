import '../../domain/php_package.dart';
import '../dto/package_detail_dto.dart';
import '../dto/package_search_dto.dart';

/// Перевод DTO в доменную модель.
///
/// Единственное место, которое правят, если изменится форма ответа API.
extension PackageSummaryDtoMapper on PackageSummaryDto {
  PhpPackage toModel() => PhpPackage(
        name: name,
        description: description,
        // В краткой выдаче поиска версии нет.
        version: '',
        downloads: compactCount(downloads),
        stars: favers,
      );
}

extension PackageDetailResponseDtoMapper on PackageDetailResponseDto {
  /// Полные данные пакета: берём последнюю стабильную версию.
  ///
  /// Версии приходят от последней к ранней, но первой может стоять
  /// пререлиз (например `v8.2.0-BETA2`) — тогда берём первый релиз.
  /// Счётчики в метаданных не хранятся, поэтому приходят отдельным
  /// аргументом из выдачи поиска.
  PhpPackage toModel(String name, {PackageSummaryDto? summary}) {
    final versionsList = this.versions.values.expand((list) => list).toList();

    // Ответ p2 minified (`minified: composer/2.0`): в старых версиях
    // Packagist опускает поля, совпадающие с более новой версией.
    // Разворачиваем наследование: absent-поля достаются от соседа
    // сверху (он новее).
    final versions = <PackageVersionDto>[];
    var carry = const PackageVersionDto();
    for (final version in versionsList) {
      carry = PackageVersionDto(
        version: version.version ?? carry.version,
        description: version.description ?? carry.description,
        require: version.require ?? carry.require,
      );
      versions.add(carry);
    }

    var latest = versions.isNotEmpty ? versions.first : const PackageVersionDto();
    for (final version in versions) {
      if (_isStable(version.version)) {
        latest = version;
        break;
      }
    }

    return PhpPackage(
      name: name,
      description: latest.description ?? '',
      version: latest.version ?? '',
      downloads: compactCount(summary?.downloads ?? 0),
      stars: summary?.favers ?? 0,
      require: latest.require ?? const {},
    );
  }
}

/// Стабильная версия: не пререлиз (`-BETA2`) и не `dev`-ветка.
bool _isStable(String? version) {
  if (version == null) return false;
  return !version.contains('-') && !version.contains('dev');
}

/// Компактная запись больших чисел: 1265544714 → `1.3B`.
String compactCount(int count) {
  if (count >= 1000000000) {
    return '${_trimZero((count / 1000000000).toStringAsFixed(1))}B';
  }
  if (count >= 1000000) {
    return '${_trimZero((count / 1000000).toStringAsFixed(1))}M';
  }
  if (count >= 1000) {
    return '${_trimZero((count / 1000).toStringAsFixed(1))}K';
  }
  return '$count';
}

/// `1.0` → `1`, чтобы счётчик читался как в ЛР2: `1B`, а не `1.0B`.
String _trimZero(String value) {
  if (value.endsWith('.0')) return value.substring(0, value.length - 2);
  return value;
}
