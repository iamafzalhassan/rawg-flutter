import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';
import 'package:rawg/features/dashboard/domain/entities/game_page.dart';

abstract interface class DashboardRepository {
  Future<ApiResult<GamePage>> getGames({int page = 1, int pageSize = 20, String? platforms, String? searchQuery});

  Future<ApiResult<GameOverview>> getGameOverview(int id);
}
