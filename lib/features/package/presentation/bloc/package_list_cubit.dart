import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/i_package_repository.dart';
import 'package_list_state.dart';

/// Управляет состоянием каталога.
///
/// Репозиторий приходит через конструктор из `RepositoryProvider`,
/// навигации Cubit не знает. Список живёт в корне приложения,
/// поэтому запрос и результат не теряются при возврате с детали.
class PackageListCubit extends Cubit<PackageListState> {
  PackageListCubit(this._repository) : super(const PackageListLoading());

  final IPackageRepository _repository;

  /// Последний отправленный запрос: ответы на устаревшие запросы
  /// отбрасываются.
  String? _latestQuery;

  /// Загружает весь каталог — тот же поиск по пустому запросу.
  Future<void> load() => search('');

  /// Ищет по имени и описанию; пустой запрос возвращает весь каталог.
  Future<void> search(String query) async {
    _latestQuery = query;

    final packages = await _repository.getAll();
    if (isClosed || _latestQuery != query) return;

    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      emit(PackageListLoaded(query: query, packages: packages));
      return;
    }

    final found = packages
        .where(
          (package) =>
              package.name.toLowerCase().contains(normalized) ||
              package.description.toLowerCase().contains(normalized),
        )
        .toList();

    if (found.isEmpty) {
      emit(PackageListNotFound(query: query));
    } else {
      emit(PackageListLoaded(query: query, packages: found));
    }
  }
}
