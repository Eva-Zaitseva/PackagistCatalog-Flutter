import 'php_package.dart';

/// Одна страница выдачи поиска.
class PackagePage {
  const PackagePage({
    required this.packages,
    required this.total,
    required this.hasMore,
  });

  final List<PhpPackage> packages;

  /// Сколько всего пакетов найдено по запросу.
  final int total;

  /// Есть ли следующая страница выдачи.
  final bool hasMore;
}
