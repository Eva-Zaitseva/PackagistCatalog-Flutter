// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageSearchResponseDto _$PackageSearchResponseDtoFromJson(
  Map<String, dynamic> json,
) => PackageSearchResponseDto(
  results: (json['results'] as List<dynamic>)
      .map((e) => PackageSummaryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt() ?? 0,
  next: json['next'] as String?,
);

PackageSummaryDto _$PackageSummaryDtoFromJson(Map<String, dynamic> json) =>
    PackageSummaryDto(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      downloads: (json['downloads'] as num?)?.toInt() ?? 0,
      favers: (json['favers'] as num?)?.toInt() ?? 0,
    );
