import 'package:flutter/foundation.dart';

import '../../domain/php_package.dart';

/// Состояние экрана пакета.
@immutable
sealed class PackageDetailState {
  const PackageDetailState();
}

class PackageDetailLoading extends PackageDetailState {
  const PackageDetailLoading();
}

class PackageDetailLoaded extends PackageDetailState {
  const PackageDetailLoaded({
    required this.package,
    required this.availableDependencies,
  });

  final PhpPackage package;

  /// Имена из `require`, которые есть в тестовом каталоге.
  /// Считает Bloc: это решение о данных, а не об отображении.
  final Set<String> availableDependencies;
}

class PackageDetailNotFound extends PackageDetailState {
  const PackageDetailNotFound(this.name);

  final String name;
}
