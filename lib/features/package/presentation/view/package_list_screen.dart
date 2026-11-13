import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(title: Text(l10n.catalog_title)),
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
                onTap: () {
                  // Навигация появится на следующем этапе вместе с роутером.
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
