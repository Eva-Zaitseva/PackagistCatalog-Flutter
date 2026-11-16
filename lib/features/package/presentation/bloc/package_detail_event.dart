import 'package:flutter/foundation.dart';

/// События экрана пакета. Имена называют то, что уже произошло.
@immutable
sealed class PackageDetailEvent {
  const PackageDetailEvent();
}

/// Открыт экран пакета с полным именем `vendor/project`.
class PackageDetailOpened extends PackageDetailEvent {
  const PackageDetailOpened(this.name);

  final String name;
}
