import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/navigation/app_router.dart';
import 'common/theme/app_theme.dart';
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
        ],
        child: MaterialApp.router(
          title: 'PackagistCatalog',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
