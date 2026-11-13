/// PHP-пакет каталога Packagist.
///
/// Доменная модель: только то, что показывает интерфейс.
/// Специфика источника данных (API, сериализация) появится в ЛР3 в слое data.
class PhpPackage {
  const PhpPackage({
    required this.name,
    required this.description,
    required this.version,
    required this.downloads,
    required this.stars,
    this.require = const {},
  });

  /// Полное имя пакета в формате `vendor/project`.
  /// Уникальный идентификатор записи: с ним пакет ищут и по нему строят путь.
  final String name;

  final String description;

  /// Версия последнего релиза, например `v12.0.0`.
  final String version;

  /// Количество загрузок в компактной записи, например `350M`.
  final String downloads;

  /// Количество звёзд на GitHub.
  final int stars;

  /// Зависимости пакета: имя → ограничение версии.
  final Map<String, String> require;
}
