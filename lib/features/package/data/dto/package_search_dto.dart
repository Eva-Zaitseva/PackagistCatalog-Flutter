import 'package:json_annotation/json_annotation.dart';

part 'package_search_dto.g.dart';

/// Ответ `search.json`: выдача, сколько всего найдено и где следующая
/// страница.
@JsonSerializable(createToJson: false)
class PackageSearchResponseDto {
  const PackageSearchResponseDto({
    required this.results,
    this.total = 0,
    this.next,
  });

  factory PackageSearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PackageSearchResponseDtoFromJson(json);

  final List<PackageSummaryDto> results;

  /// Сколько всего пакетов найдено по запросу.
  final int total;

  /// Адрес следующей страницы выдачи или `null`, если это последняя.
  final String? next;
}

/// Краткая запись пакета в выдаче поиска.
@JsonSerializable(createToJson: false)
class PackageSummaryDto {
  const PackageSummaryDto({
    required this.name,
    this.description = '',
    this.downloads = 0,
    this.favers = 0,
  });

  factory PackageSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$PackageSummaryDtoFromJson(json);

  /// Полное имя пакета, `vendor/project`.
  final String name;

  final String description;

  /// Загрузки пакета за всё время.
  final int downloads;

  /// «Звёзды» пакета на GitHub.
  final int favers;
}
