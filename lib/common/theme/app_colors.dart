import 'package:flutter/material.dart';

/// Палитра каталога: сырые цвета без привязки к фичам.
///
/// Экраны не используют этот класс напрямую — цвета приходят
/// через [AppTheme] в `ColorScheme`, а оттуда через `Theme.of(context)`.
class AppColors {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainer,
    required this.onSurfaceVariant,
    required this.outline,
    required this.error,
    required this.onError,
  });

  /// Светлая палитра, опорный цвет — индиго #5146A5.
  static const AppColors light = AppColors(
    primary: Color(0xFF5146A5),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8E3FF),
    onPrimaryContainer: Color(0xFF1B1460),
    secondary: Color(0xFF554F63),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFAF9FF),
    onSurface: Color(0xFF0D0D11),
    surfaceContainer: Color(0xFFEFEDF8),
    onSurfaceVariant: Color(0xFF3B383F),
    outline: Color(0xFF797680),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
  );

  /// Тёмная палитра: те же роли, поверхности темнеют, подписи светлеют.
  static const AppColors dark = AppColors(
    primary: Color(0xFFC7BFFF),
    onPrimary: Color(0xFF2B236F),
    primaryContainer: Color(0xFF40378A),
    onPrimaryContainer: Color(0xFFE8E3FF),
    secondary: Color(0xFFCBC3D9),
    onSecondary: Color(0xFF332D40),
    surface: Color(0xFF131318),
    onSurface: Color(0xFFE5E1E9),
    surfaceContainer: Color(0xFF1F1E26),
    onSurfaceVariant: Color(0xFFCAC5D0),
    outline: Color(0xFF938F9A),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
  );

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainer;
  final Color onSurfaceVariant;
  final Color outline;
  final Color error;
  final Color onError;
}
