import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/localization/locale_cubit.dart';
import 'common/navigation/app_router.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/theme_cubit.dart';
import 'features/package/data/package_repository.dart';
import 'features/package/domain/i_package_repository.dart';
import 'features/package/presentation/bloc/package_list_cubit.dart';
import 'l10n/generated/app_localizations.dart';

/// Корень приложения: репозиторий и общие Cubit регистрируются здесь,
/// выше MaterialApp.
class PackagistCatalogApp extends StatelessWidget {
  const PackagistCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IPackageRepository>(
          create: (_) => const PackageRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Список в корне: запрос и результат не теряются при
          // переходе на деталь и обратно.
          BlocProvider<PackageListCubit>(
            create: (context) =>
                PackageListCubit(context.read<IPackageRepository>())..load(),
          ),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        ],
        child: const _AppView(),
      ),
    );
  }
}

/// Отдельный виджет ниже провайдеров, чтобы читать их состояния
/// через `context.watch`.
class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state.mode;
    final locale = context.watch<LocaleCubit>().state.locale;

    return MaterialApp.router(
      title: 'PackagistCatalog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
