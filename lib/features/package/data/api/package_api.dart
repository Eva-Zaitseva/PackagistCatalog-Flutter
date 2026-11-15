import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../common/network/dio_client.dart';
import '../dto/package_detail_dto.dart';
import '../dto/package_search_dto.dart';

/// HTTP-клиент Packagist: один метод на один адрес.
///
/// Общая настройка (таймауты, лог, агент) — в Dio из корня приложения;
/// метод знает только свой путь и параметры.
class PackageApi {
  const PackageApi(this._dio);

  final Dio _dio;

  /// Поиск пакетов: `GET packagist.org/search.json?q=...&page=N`.
  Future<PackageSearchResponseDto> search(String query, {int page = 1}) async {
    final response = await _dio.get<String>(
      '${PackagistHosts.search}/search.json',
      queryParameters: {
        'q': query,
        if (page > 1) 'page': page,
      },
      options: Options(responseType: ResponseType.plain),
    );
    return PackageSearchResponseDto.fromJson(
      jsonDecode(response.data ?? '{}') as Map<String, dynamic>,
    );
  }

  /// Метаданные пакета: `GET repo.packagist.org/p2/{name}.json`.
  ///
  /// Слэш в имени (`laravel/framework`) не кодируется: именно так
  /// Packagist хранит и отдаёт путь к метаданным.
  Future<PackageDetailResponseDto> package(String name) async {
    final response = await _dio.get<String>(
      '${PackagistHosts.metadata}/p2/$name.json',
      options: Options(responseType: ResponseType.plain),
    );
    return PackageDetailResponseDto.fromJson(
      jsonDecode(response.data ?? '{}') as Map<String, dynamic>,
    );
  }
}
