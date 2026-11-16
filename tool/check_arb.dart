// Проверяет, что во всех ARB-файлах совпадают наборы ключей и имена
// плейсхолдеров. gen_l10n молча пропускает ключ, забытый в одном из ARB,
// поэтому расхождения ищем отдельным скриптом.
//
// Запуск из корня проекта: dart run tool/check_arb.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const String _arbDir = 'lib/l10n';
const String _templateFile = 'app_ru.arb';

void main() {
  final arbFiles = Directory(_arbDir)
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList();

  if (arbFiles.length < 2) {
    stderr.writeln('В $_arbDir меньше двух ARB-файлов — проверять нечего.');
    exit(1);
  }

  final templatePath = '$_arbDir/$_templateFile';
  final template = _readArb(templatePath);
  var hasErrors = false;

  for (final file in arbFiles) {
    if (_normalizePath(file.path) == _normalizePath(templatePath)) continue;

    final other = _readArb(file.path);
    hasErrors |= _checkKeys(template, other, file.path);
    hasErrors |= _checkPlaceholders(template, other, file.path);
  }

  if (hasErrors) {
    stderr.writeln('ARB-файлы не согласованы. Исправьте расхождения выше.');
    exit(1);
  }
  stdout.writeln(
    'ARB-файлы согласованы: ${arbFiles.length} файла, '
    '${template.keys.where((key) => !key.startsWith('@')).length} подписей.',
  );
}

/// Ключи подписей (без метаданных `@ключ`) и их плейсхолдеры.
Map<String, Map<String, Set<String>>> _readArb(String path) {
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  final result = <String, Map<String, Set<String>>>{};

  for (final key in raw.keys) {
    if (key.startsWith('@')) continue;
    final meta = raw['@$key'];
    final placeholders = meta is Map && meta['placeholders'] is Map
        ? (meta['placeholders'] as Map).keys.cast<String>().toSet()
        : <String>{};
    result[key] = {
      'placeholders': placeholders,
    };
  }
  return result;
}

bool _checkKeys(
  Map<String, Map<String, Set<String>>> template,
  Map<String, Map<String, Set<String>>> other,
  String path,
) {
  var hasErrors = false;
  for (final key in template.keys) {
    if (!other.containsKey(key)) {
      print('[$path] нет ключа "$key", который есть в шаблоне');
      hasErrors = true;
    }
  }
  for (final key in other.keys) {
    if (!template.containsKey(key)) {
      print('[$path] лишний ключ "$key" — его нет в шаблоне');
      hasErrors = true;
    }
  }
  return hasErrors;
}

bool _checkPlaceholders(
  Map<String, Map<String, Set<String>>> template,
  Map<String, Map<String, Set<String>>> other,
  String path,
) {
  var hasErrors = false;
  for (final key in template.keys) {
    if (!other.containsKey(key)) continue;
    final expected = template[key]!['placeholders']!;
    final actual = other[key]!['placeholders']!;
    if (!_sameSet(expected, actual)) {
      print(
        '[$path] у ключа "$key" плейсхолдеры $actual '
        'не совпадают с шаблонными $expected',
      );
      hasErrors = true;
    }
  }
  return hasErrors;
}

bool _sameSet(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

String _normalizePath(String path) => path.replaceAll('\\', '/');
