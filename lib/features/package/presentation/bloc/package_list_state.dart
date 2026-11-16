import 'package:flutter/foundation.dart';

import '../../../../common/network/load_exception.dart';
import '../../domain/php_package.dart';

/// Состояние экрана каталога.
@immutable
sealed class PackageListState {
  const PackageListState();
}

/// Каталог ещё не пришёл.
class PackageListLoading extends PackageListState {
  const PackageListLoading();
}

/// Список на экране. Хранит всё для пагинации: есть ли следующая
/// страница, какой её номер и как идёт догрузка.
class PackageListLoaded extends PackageListState {
  const PackageListLoaded({
    required this.query,
    required this.packages,
    required this.total,
    required this.hasMore,
    required this.nextPage,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  /// Запрос, по которому собран список. Пустой — весь каталог.
  final String query;

  final List<PhpPackage> packages;

  /// Сколько всего пакетов найдено по запросу (из ответа API).
  final int total;

  /// Есть ли следующая страница.
  final bool hasMore;

  /// Номер следующей страницы.
  final int nextPage;

  /// Идёт ли догрузка следующей страницы.
  final bool isLoadingMore;

  /// Оборвалась ли предыдущая догрузка.
  final bool loadMoreFailed;

  PackageListLoaded copyWith({
    bool? isLoadingMore,
    bool? loadMoreFailed,
  }) {
    return PackageListLoaded(
      query: query,
      packages: packages,
      total: total,
      hasMore: hasMore,
      nextPage: nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }
}

/// По запросу нет ни одного пакета.
class PackageListNotFound extends PackageListState {
  const PackageListNotFound({required this.query});

  final String query;
}

/// Список загрузить не удалось.
class PackageListFailure extends PackageListState {
  const PackageListFailure({
    required this.query,
    required this.exception,
  });

  /// Запрос, который не удалось выполнить: по нему же и повторяем.
  final String query;

  final LoadException exception;
}
