import 'package:flutter/foundation.dart';

import '../../domain/php_package.dart';

/// Состояние экрана каталога.
///
/// Один неизменяемый тип: `Loading` — каталог ещё не пришёл,
/// `Loaded` — список на экране, `NotFound` — по запросу ничего нет.
@immutable
sealed class PackageListState {
  const PackageListState();
}

class PackageListLoading extends PackageListState {
  const PackageListLoading();
}

class PackageListLoaded extends PackageListState {
  const PackageListLoaded({
    required this.query,
    required this.packages,
  });

  /// Запрос, по которому собран список. Пустой — весь каталог.
  final String query;

  final List<PhpPackage> packages;
}

class PackageListNotFound extends PackageListState {
  const PackageListNotFound({required this.query});

  final String query;
}
