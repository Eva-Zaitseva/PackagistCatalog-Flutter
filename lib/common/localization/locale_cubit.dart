import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Язык интерфейса всего приложения.
class LocaleState {
  const LocaleState(this.locale);

  /// `null` — использовать язык системы.
  final Locale? locale;
}

/// Переключает язык подписей интерфейса (ru/en).
///
/// Данные каталога не переводятся. Значение живёт только в памяти:
/// сохранение на диск в ЛР2 запрещено.
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(null));

  void setSystem() => emit(const LocaleState(null));

  void setRussian() => emit(const LocaleState(Locale('ru')));

  void setEnglish() => emit(const LocaleState(Locale('en')));
}
