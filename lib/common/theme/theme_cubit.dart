import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Режим темы всего приложения.
class ThemeState {
  const ThemeState(this.mode);

  /// `system` — следовать за системной темой.
  final ThemeMode mode;
}

/// Переключает светлую/тёмную/системную тему.
///
/// Значение живёт только в памяти: сохранение на диск в ЛР2 запрещено.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  void set(ThemeMode mode) => emit(ThemeState(mode));
}
