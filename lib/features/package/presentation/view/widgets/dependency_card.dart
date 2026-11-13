import 'package:flutter/material.dart';

import '../../../../../l10n/generated/app_localizations.dart';

/// Карточка зависимости в списке `require`.
///
/// Если зависимость есть в тестовом каталоге — кнопка перехода,
/// иначе подпись «нет в тестовом каталоге».
class DependencyCard extends StatelessWidget {
  const DependencyCard({
    super.key,
    required this.name,
    required this.version,
    required this.isAvailable,
    this.onOpenTap,
  });

  final String name;
  final String version;
  final bool isAvailable;
  final VoidCallback? onOpenTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.version(version),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            if (isAvailable)
              TextButton.icon(
                onPressed: onOpenTap,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(l10n.open_package),
              )
            else
              Text(
                l10n.package_not_found,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
