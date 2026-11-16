import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Экран для неизвестных адресов: go_router показывает его
/// вместо белой страницы ошибки.
class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(l10n.page_not_found,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
