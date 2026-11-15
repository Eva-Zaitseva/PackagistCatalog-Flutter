import 'package:dio/dio.dart';

/// Адреса хостов Packagist.
///
/// Единственное место в приложении, где они заданы: поиск и метаданные
/// лежат на разных хостах, но менять адреса нужно только здесь.
abstract final class PackagistHosts {
  /// Поиск и каталог: `https://packagist.org/search.json`.
  static const search = 'https://packagist.org';

  /// Метаданные пакета: `https://repo.packagist.org/p2/{name}.json`.
  static const metadata = 'https://repo.packagist.org';
}

/// Debug-режим без зависимости от flutter/foundation: тот же признак,
/// по которому Flutter отличает release (в debug `dart.vm.product` = false).
/// Так dio_client можно использовать и вне Flutter, например в probe-скриптах.
const bool _kDebugLog = !bool.fromEnvironment('dart.vm.product');

/// Создаёт настроенный Dio.
///
/// Вызывается один раз в корне приложения; дальше Dio передаётся
/// API-клиенту через конструктор.
Dio createDio() {
  final dio = Dio();
  dio.options
    ..connectTimeout = const Duration(seconds: 10)
    ..receiveTimeout = const Duration(seconds: 20)
    // Packagist просит указывать контакт в User-Agent.
    ..headers['User-Agent'] = 'PackagistCatalog-Lab/1.0 (flutter study app)';

  if (_kDebugLog) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }
  return dio;
}
