import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../network/load_exception.dart';

/// Вид ошибки загрузки: подпись по типу ошибки и кнопка «Повторить».
class LoadErrorView extends StatelessWidget {
  const LoadErrorView({
    super.key,
    required this.exception,
    required this.onRetry,
  });

  final LoadException exception;
  final VoidCallback onRetry;

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
              Icons.cloud_off_outlined,
              size: 64,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error_loading_title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              exception.message(l10n),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Подпись ошибки по её виду.
extension LoadExceptionMessage on LoadException {
  String message(AppLocalizations l10n) {
    return switch (this) {
      LoadNetworkException() => l10n.error_network,
      LoadTimeoutException() => l10n.error_timeout,
      LoadClientException() => l10n.error_client,
      LoadServerException() => l10n.error_server,
      LoadDataException() => l10n.error_data,
    };
  }
}
