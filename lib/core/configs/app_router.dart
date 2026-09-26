import 'package:go_router/go_router.dart';
import 'package:rawg/core/constants/route_constants.dart';
import 'package:rawg/core/di/injection_container.dart';
import 'package:rawg/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:rawg/features/auth/presentation/pages/auth_page.dart';
import 'package:rawg/features/dashboard/domain/entities/game.dart';
import 'package:rawg/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:rawg/features/dashboard/presentation/pages/game_overview_page.dart';
import 'package:rawg/features/settings/presentation/pages/settings_page.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final isAuthenticated = serviceLocator<GetCurrentUserUseCase>()() != null;
      if (isAuthenticated != (state.matchedLocation == '/auth')) return null;
      return isAuthenticated ? '/dashboard' : '/auth';
    },
    routes: [
      GoRoute(builder: (context, state) => const AuthPage(), name: RouteConstants.auth, path: '/auth'),
      GoRoute(
        builder: (context, state) => const DashboardPage(),
        name: RouteConstants.dashboard,
        path: '/dashboard',
        routes: [GoRoute(builder: (context, state) => GameOverviewPage(state.extra as Game), name: RouteConstants.gameOverview, path: 'game-overview')],
      ),
      GoRoute(builder: (context, state) => const SettingsPage(), name: RouteConstants.settings, path: '/settings'),
    ],
  );
}
