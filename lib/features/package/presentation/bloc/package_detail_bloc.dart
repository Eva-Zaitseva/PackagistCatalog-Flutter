import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/network/load_exception.dart';
import '../../domain/i_package_repository.dart';
import '../../domain/php_package.dart';
import 'package_detail_event.dart';
import 'package_detail_state.dart';

/// Управляет состоянием одного открытого экрана пакета.
///
/// Bloc создаётся вместе со своим экраном и закрывается вместе с ним,
/// навигации не знает.
class PackageDetailBloc extends Bloc<PackageDetailEvent, PackageDetailState> {
  PackageDetailBloc(IPackageRepository repository)
      : _repository = repository,
        super(const PackageDetailLoading()) {
    on<PackageDetailOpened>(_onOpened);
  }

  final IPackageRepository _repository;

  /// Сколько зависимостей проверяем на существование. Проверка идёт
  /// отдельным запросом на каждую, поэтому ограничиваем список.
  static const _maxExistenceChecks = 8;

  Future<void> _onOpened(
    PackageDetailOpened event,
    Emitter<PackageDetailState> emit,
  ) async {
    final PhpPackage? package;
    try {
      package = await _repository.getByName(event.name);
    } on LoadException catch (exception) {
      if (isClosed) return;
      emit(PackageDetailFailure(name: event.name, exception: exception));
      return;
    }
    if (isClosed) return;

    if (package == null) {
      emit(PackageDetailNotFound(event.name));
      return;
    }

    // Данные показываем сразу; наличие зависимостей уточняется следом.
    emit(PackageDetailLoaded(
      package: package,
      availableDependencies: const {},
    ));

    // Зависимости — связанные записи. Проверяем их существование
    // параллельно, а не циклом подряд. У каждой проверки своя ошибка:
    // упала — зависимость просто «не найдена», экран не валим.
    final candidates = package.require.keys
        .where(
          (name) => !name.startsWith('php') && !name.startsWith('ext-'),
        )
        .take(_maxExistenceChecks);

    final checks = candidates.map((name) async {
      try {
        return await _repository.exists(name) ? name : null;
      } on LoadException {
        return null;
      }
    }).toList();

    final available = await Future.wait(checks);
    if (isClosed) return;

    emit(PackageDetailLoaded(
      package: package,
      availableDependencies: available.whereType<String>().toSet(),
    ));
  }
}
