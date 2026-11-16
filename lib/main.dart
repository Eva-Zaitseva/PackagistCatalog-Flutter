import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app.dart';

void main() {
  // push по умолчанию не меняет адрес; включаем отражение в URL.
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const PackagistCatalogApp());
}
