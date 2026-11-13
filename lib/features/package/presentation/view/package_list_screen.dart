import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/localization/locale_cubit.dart';
import '../../../../common/theme/theme_cubit.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/php_package.dart';
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
        actions: const [
          _ThemeMenu(),
          _LanguageMenu(),
        ],
      ),
      body: BlocBuilder<PackageListCubit, PackageListState>(
        builder: (context, state) {
          return switch (state) {
            PackageListLoading() =>
              const Center(child: CircularProgressIndicator()),
            PackageListLoaded(:final query, :final packages) => _CatalogBody(
                query: query,
                packages: packages,
              ),
            PackageListNotFound(:final query) => _CatalogBody(
                query: query,
                packages: const [],
              ),
          };
        },
      ),
    );
  }
}

/// Поле поиска и содержимое каталога: список или «ничего не найдено».
///
/// Один виджет для Loaded и NotFound, чтобы поле поиска
/// не пересоздавалось при смене состояния — фокус не теряется.
class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.query,
    required this.packages,
  });

  final String query;
  final List<PhpPackage> packages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: _SearchField(query: query),
        ),
        if (packages.isEmpty)
          Expanded(
            child: _NotFoundView(query: query),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l10n.package_count(packages.length),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: _PackageListView(packages: packages),
          ),
        ],
      ],
    );
  }
}

/// Поле поиска. Контроллер создаётся один раз в initState,
/// иначе при каждой перерисовке курсор прыгал бы в начало.
class _SearchField extends StatefulWidget {
  const _SearchField({required this.query});

  final String query;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(_SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Запрос пришёл из состояния Cubit (например, после сброса кнопкой);
    // своё содержимое поля не перетираем, чтобы не рвать ввод.
    if (widget.query != oldWidget.query && widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() {}); // прячет/показывает кнопку сброса
        context.read<PackageListCubit>().search(value);
      },
      onSubmitted: (value) => context.read<PackageListCubit>().search(value),
      decoration: InputDecoration(
        labelText: l10n.search_packages,
        hintText: l10n.search_hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Сбрасываем и поле, и запрос: иначе список очистится,
                  // а текст в поле останется.
                  _controller.clear();
                  context.read<PackageListCubit>().search('');
                  setState(() {});
                },
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: 1,
    );  }
}

/// Список пакетов.
class _PackageListView extends StatelessWidget {
  const _PackageListView({required this.packages});

  final List<PhpPackage> packages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // PageStorageKey сохраняет позицию прокрутки, даже если
      // дерево списка пересоздаётся.
      key: const PageStorageKey('package-list'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: packages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final package = packages[index];
        return PackageCard(
          package: package,
          // Имя содержит '/', в пути оно идёт закодированным.
          onTap: () {
            context.push('/package/${Uri.encodeComponent(package.name)}');
          },
        );
      },
    );
  }
}

/// Экран «ничего не найдено».
class _NotFoundView extends StatelessWidget {
  const _NotFoundView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.nothing_found_title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.nothing_found_subtitle(query),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
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
