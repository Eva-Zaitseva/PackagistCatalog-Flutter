import 'package:dio/dio.dart';

import '../../../../common/network/load_exception.dart';
import '../api/package_api.dart';
import '../dto/package_detail_dto.dart';
import '../dto/package_search_dto.dart';
import 'i_package_data_source.dart';

/// Сетевой датасорс: вызывает API-клиент и переводит ошибки dio
/// в свои LoadException.
///
/// Выше датасорса ничего не знает про dio: наверх идут только DTO
/// и LoadException.
class NetworkPackageDataSource implements IPackageDataSource {
  const NetworkPackageDataSource(this._api);

  final PackageApi _api;

  @override
  Future<PackageSearchResponseDto> search(String query, {int page = 1}) async {
    try {
      return await _api.search(query, page: page);
    } on DioException catch (exception) {
      throw _toLoadException(exception);
    } on FormatException catch (_) {
      throw const LoadDataException();
    } on TypeError catch (_) {
      throw const LoadDataException();
    }
  }

  @override
  Future<PackageDetailResponseDto> getPackage(String name) async {
    try {
      return await _api.package(name);
    } on DioException catch (exception) {
      throw _toLoadException(exception);
    } on FormatException catch (_) {
      throw const LoadDataException();
    } on TypeError catch (_) {
      throw const LoadDataException();
    }
  }

  /// Классификация ошибок dio по типам.
  LoadException _toLoadException(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const LoadTimeoutException(),
      DioExceptionType.badResponse => _byStatusCode(exception.response?.statusCode),
      // connectionError, badCertificate, cancel и unknown —
      // всё это не дошедший или оборвавшийся запрос.
      _ => const LoadNetworkException(),
    };
  }

  LoadException _byStatusCode(int? statusCode) {
    if (statusCode != null && statusCode >= 500) {
      return LoadServerException(statusCode);
    }
    return LoadClientException(statusCode);
  }
}
