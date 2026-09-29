import 'package:rawg/core/constants/api_constants.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/dashboard/domain/entities/game_page.dart';
import 'package:rawg/features/dashboard/domain/repository/dashboard_repository.dart';

class GetGamesUseCase {
  final DashboardRepository _dashboardRepository;

  GetGamesUseCase(this._dashboardRepository);

  Future<ApiResult<GamePage>> call({int page = 1, int pageSize = ApiConstants.pageSize, String? platforms, String? searchQuery}) =>
      _dashboardRepository.getGames(page: page, pageSize: pageSize, platforms: platforms, searchQuery: searchQuery);
}
