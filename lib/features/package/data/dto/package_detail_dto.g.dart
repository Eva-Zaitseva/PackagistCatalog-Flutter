// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageDetailResponseDto _$PackageDetailResponseDtoFromJson(
  Map<String, dynamic> json,
) => PackageDetailResponseDto(
  versions: (json['packages'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => PackageVersionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

PackageVersionDto _$PackageVersionDtoFromJson(Map<String, dynamic> json) =>
    PackageVersionDto(
      version: json['version'] as String?,
      description: json['description'] as String?,
      require: (json['require'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );
