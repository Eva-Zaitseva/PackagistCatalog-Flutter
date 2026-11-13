import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/i_package_repository.dart';
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

  Future<void> _onOpened(
    PackageDetailOpened event,
    Emitter<PackageDetailState> emit,
  ) async {
    final package = await _repository.getByName(event.name);
    if (package == null) {
      emit(PackageDetailNotFound(event.name));
      return;
    }

    final catalogNames =
        (await _repository.getAll()).map((item) => item.name).toSet();
    final available = package.require.keys
        .where(catalogNames.contains)
        .toSet();

    emit(PackageDetailLoaded(
      package: package,
      availableDependencies: available,
    ));
  }
}
