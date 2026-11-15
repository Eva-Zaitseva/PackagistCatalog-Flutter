/// Ошибка загрузки данных из сети, понятная слоям выше датасорса.
///
/// Датасорс переводит исключения dio в эти подтипы. Cubit, Bloc и экраны
/// про dio не знают — они различают только вид ошибки.
sealed class LoadException implements Exception {
  const LoadException();
}

/// Нет сети или соединение оборвалось.
class LoadNetworkException extends LoadException {
  const LoadNetworkException();
}

/// Сервер не ответил за отведённое время.
class LoadTimeoutException extends LoadException {
  const LoadTimeoutException();
}

/// Сервер отклонил запрос: код ответа 4xx.
class LoadClientException extends LoadException {
  const LoadClientException(this.statusCode);

  /// HTTP-код ответа, если он известен.
  final int? statusCode;
}

/// Ошибка на стороне сервера: код ответа 5xx.
class LoadServerException extends LoadException {
  const LoadServerException(this.statusCode);

  /// HTTP-код ответа, если он известен.
  final int? statusCode;
}

/// Сервер ответил, но тело разобрать не удалось:
/// это не JSON или не ожидаемая форма.
class LoadDataException extends LoadException {
  const LoadDataException();
}
