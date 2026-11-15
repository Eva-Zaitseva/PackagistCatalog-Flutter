import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/network/load_exception.dart';
import '../../domain/i_package_repository.dart';
import 'package_list_state.dart';

/// Управляет состоянием каталога.
///
/// Репозиторий приходит через конструктор из `RepositoryProvider`.
/// Список живёт в корне приложения, поэтому запрос и результат
/// не теряются при возврате с детали.
class PackageListCubit extends Cubit<PackageListState> {
  PackageListCubit(this._repository) : super(const PackageListLoading());

  final IPackageRepository _repository;

  /// Номер последнего отправленного запроса. Сеть непредсказуема по
  /// времени: ответ на устаревший запрос (пользователь уже поменял
  /// условие поиска) отбрасывается.
  int _seq = 0;

  /// Открывает каталог: тот же поиск, пустой запрос = весь каталог.
  Future<void> load() => search('');

  /// Ищет по имени и описанию; пустой запрос возвращает весь каталог.
  Future<void> search(String query) async {
    final seq = ++_seq;
    emit(PackageListLoading());

    try {
      final page = await _repository.search(query);
      if (isClosed || _seq != seq) return;

      if (page.packages.isEmpty) {
        emit(PackageListNotFound(query: query));
      } else {
        emit(PackageListLoaded(
          query: query,
          packages: page.packages,
          total: page.total,
          hasMore: page.hasMore,
          nextPage: 2,
        ));
      }
    } on LoadException catch (exception) {
      if (isClosed || _seq != seq) return;
      emit(PackageListFailure(query: query, exception: exception));
    }
  }

  /// Догружает следующую страницу к уже показанному списку.
  Future<void> loadMore() async {
    final current = state;
    if (current is! PackageListLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;

    final seq = _seq;
    final captured = current;
    emit(captured.copyWith(isLoadingMore: true));

    try {
      final page = await _repository.search(
        captured.query,
        page: captured.nextPage,
      );
      if (isClosed || _seq != seq) return;

      // Между запросами выдача могла измениться: убираем повторы.
      final known = captured.packages.map((item) => item.name).toSet();
      final fresh = page.packages
          .where((item) => !known.contains(item.name))
          .toList();

      emit(PackageListLoaded(
        query: captured.query,
        packages: [...captured.packages, ...fresh],
        total: page.total,
        hasMore: page.hasMore,
        nextPage: captured.nextPage + 1,
      ));
    } on LoadException {
      if (isClosed || _seq != seq) return;

      // Обрыв догрузки — не ошибка экрана: список остаётся на месте,
      // внизу появляется «Повторить», грузится та же страница.
      emit(captured.copyWith(isLoadingMore: false, loadMoreFailed: true));
    }
  }
}
