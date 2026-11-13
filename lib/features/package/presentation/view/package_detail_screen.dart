import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../bloc/package_detail_bloc.dart';
import '../bloc/package_detail_state.dart';
import 'widgets/dependency_card.dart';

/// Экран пакета: описание, счётчики и зависимости.
///
/// Связанную запись открываем через `push`, чтобы «назад»
/// возвращало по одному экрану.
class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.package_information)),
      body: BlocBuilder<PackageDetailBloc, PackageDetailState>(
        builder: (context, state) {
          return switch (state) {
            PackageDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            PackageDetailNotFound() => Center(
                child: Text(l10n.detail_not_found),
              ),
            PackageDetailLoaded(
              :final package,
              :final availableDependencies,
            ) =>
              _DetailView(
                packageName: package.name,
                description: package.description,
                version: package.version,
                downloads: package.downloads,
                stars: package.stars,
                dependencies: package.require,
                availableDependencies: availableDependencies,
              ),
          };
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({
    required this.packageName,
    required this.description,
    required this.version,
    required this.downloads,
    required this.stars,
    required this.dependencies,
    required this.availableDependencies,
  });

  final String packageName;
  final String description;
  final String version;
  final String downloads;
  final int stars;
  final Map<String, String> dependencies;
  final Set<String> availableDependencies;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(packageName, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FactRow(icon: Icons.tag, text: l10n.version(version)),
                _FactRow(icon: Icons.download_outlined, text: l10n.downloads(downloads)),
                _FactRow(icon: Icons.star_border, text: l10n.stars(stars)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.dependencies_title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (dependencies.isEmpty)
          Text(l10n.no_dependencies)
        else
          ...dependencies.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DependencyCard(
                name: entry.key,
                version: entry.value,
                isAvailable: availableDependencies.contains(entry.key),
                onOpenTap: () {
                  final path =
                      '/package/${Uri.encodeComponent(entry.key)}';
                  context.push(path);
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
