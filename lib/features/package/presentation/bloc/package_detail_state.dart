import 'package:flutter/foundation.dart';

import '../../../../common/network/load_exception.dart';
import '../../domain/php_package.dart';

/// Состояние экрана пакета.
@immutable
sealed class PackageDetailState {
  const PackageDetailState();
}

/// Данные ещё не пришли.
class PackageDetailLoading extends PackageDetailState {
  const PackageDetailLoading();
}

/// Данные на экране.
class PackageDetailLoaded extends PackageDetailState {
  const PackageDetailLoaded({
    required this.package,
    required this.availableDependencies,
  });

  final PhpPackage package;

  /// Зависимости, которые существуют в каталоге: по ним есть переход.
  /// Считает Bloc: это решение о данных, а не об отображении.
  final Set<String> availableDependencies;
}

/// Пакета с таким именем нет.
class PackageDetailNotFound extends PackageDetailState {
  const PackageDetailNotFound(this.name);

  final String name;
}

/// Данные загрузить не удалось.
class PackageDetailFailure extends PackageDetailState {
  const PackageDetailFailure({
    required this.name,
    required this.exception,
  });

  /// Имя пакета, по которому повторяем загрузку.
  final String name;

  final LoadException exception;
}
