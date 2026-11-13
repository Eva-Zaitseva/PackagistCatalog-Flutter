import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/localization/locale_cubit.dart';
import '../../../../common/theme/theme_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/package_list_cubit.dart';
import '../bloc/package_list_state.dart';
import 'widgets/package_card.dart';

/// Экран каталога PHP-пакетов.
///
/// Экран рисует состояние Cubit и вызывает его методы,
/// решений сам не принимает.
class PackageListScreen extends StatelessWidget {
  const PackageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.catalog_title),
        actions: [
          const _ThemeMenu(),
          const _LanguageMenu(),
        ],
      ),
      body: BlocBuilder<PackageListCubit, PackageListState>(
        builder: (context, state) {
          return switch (state) {
            PackageListLoading() =>
              const Center(child: CircularProgressIndicator()),
            PackageListLoaded() => _CatalogView(state: state),
          };
        },
      ),
    );
  }
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({required this.state});

  final PackageListLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            l10n.package_count(state.packages.length),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(
          child: ListView.separated(
            // PageStorageKey сохраняет позицию прокрутки, даже если
            // дерево списка пересоздаётся.
            key: const PageStorageKey('package-list'),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: state.packages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final package = state.packages[index];
              return PackageCard(
                package: package,
                // Имя содержит '/', в пути оно идёт закодированным.
                onTap: () {
                  context.push('/package/${Uri.encodeComponent(package.name)}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Кнопка меню в шапке: выбор режима темы.
class _ThemeMenu extends StatelessWidget {
  const _ThemeMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.brightness_6_outlined),
      tooltip: l10n.theme_setting,
      onSelected: (mode) => context.read<ThemeCubit>().set(mode),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.system,
          child: Text(l10n.theme_system),
        ),
        PopupMenuItem(
          value: ThemeMode.light,
          child: Text(l10n.theme_light),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Text(l10n.theme_dark),
        ),
      ],
    );
  }
}

/// Кнопка меню в шапке: выбор языка подписей интерфейса.
class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: l10n.language_setting,
      onSelected: (value) {
        final cubit = context.read<LocaleCubit>();
        switch (value) {
          case 'ru':
            cubit.setRussian();
          case 'en':
            cubit.setEnglish();
          default:
            cubit.setSystem();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'system',
          child: Text(l10n.language_system),
        ),
        PopupMenuItem(
          value: 'ru',
          child: Text(l10n.language_russian),
        ),
        PopupMenuItem(
          value: 'en',
          child: Text(l10n.language_english),
        ),
      ],
    );
  }
}
