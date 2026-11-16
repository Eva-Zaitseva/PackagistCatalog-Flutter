import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/package/domain/i_package_repository.dart';
import '../../features/package/presentation/bloc/package_detail_bloc.dart';
import '../../features/package/presentation/bloc/package_detail_event.dart';
import '../../features/package/presentation/view/package_detail_screen.dart';
import '../../features/package/presentation/view/package_list_screen.dart';
import '../widgets/page_not_found_screen.dart';

/// Экраны переходят через `context.push`; включаем отражение
/// императивных переходов в URL, чтобы адресная строка всегда
/// показывала настоящий путь (включается в main.dart).
final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const PageNotFoundScreen(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PackageListScreen(),
    ),
    GoRoute(
      // Имя пакета содержит '/', поэтому в пути оно в виде
      // %2F: /package/laravel%2Fframework
      path: '/package/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        return BlocProvider<PackageDetailBloc>(
          create: (context) =>
              PackageDetailBloc(context.read<IPackageRepository>())
                ..add(PackageDetailOpened(name)),
          child: const PackageDetailScreen(),
        );
      },
    ),
  ],
);
