import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';
import 'package:rawg/features/dashboard/domain/repository/dashboard_repository.dart';

class GetGameOverviewUseCase {
  final DashboardRepository _dashboardRepository;

  GetGameOverviewUseCase(this._dashboardRepository);

  Future<ApiResult<GameOverview>> call(int id) => _dashboardRepository.getGameOverview(id);
}
