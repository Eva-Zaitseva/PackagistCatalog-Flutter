import 'package:flutter/foundation.dart';

import '../../domain/php_package.dart';

/// Состояние экрана каталога.
///
/// Один неизменяемый тип: `Loading` — каталог ещё не пришёл,
/// `Loaded` — список на экране и запрос, по которому он собран.
@immutable
sealed class PackageListState {
  const PackageListState();
}

class PackageListLoading extends PackageListState {
  const PackageListLoading();
}

class PackageListLoaded extends PackageListState {
  const PackageListLoaded({required this.packages});

  final List<PhpPackage> packages;
}
