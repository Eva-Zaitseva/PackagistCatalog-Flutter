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

  /// Загружает весь каталог.
  Future<void> load() async {
    final packages = await _repository.getAll();
    if (isClosed) return;
    emit(PackageListLoaded(packages: packages));
  }
}
