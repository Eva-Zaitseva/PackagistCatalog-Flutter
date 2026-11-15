import 'package:json_annotation/json_annotation.dart';

part 'package_detail_dto.g.dart';

/// Ответ `p2/{name}.json`: все версии пакета.
@JsonSerializable(createToJson: false)
class PackageDetailResponseDto {
  const PackageDetailResponseDto({required this.versions});

  factory PackageDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PackageDetailResponseDtoFromJson(json);

  /// Версии пакета: ключ — полное имя, значение — список версий
  /// от последней к ранним (по времени публикации).
  @JsonKey(name: 'packages')
  final Map<String, List<PackageVersionDto>> versions;
}

/// Одна версия пакета.
@JsonSerializable(createToJson: false)
class PackageVersionDto {
  const PackageVersionDto({
    this.version,
    this.description,
    this.require,
  });

  factory PackageVersionDto.fromJson(Map<String, dynamic> json) =>
      _$PackageVersionDtoFromJson(json);

  /// Строка версии, например `v8.2.0-BETA2`.
  final String? version;

  final String? description;

  /// Зависимости этой версии: имя → ограничение.
  final Map<String, String>? require;
}
