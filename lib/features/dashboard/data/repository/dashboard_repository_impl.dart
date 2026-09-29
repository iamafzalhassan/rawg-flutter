import 'package:easy_localization/easy_localization.dart';
import 'package:rawg/core/constants/api_constants.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/core/network/connection_checker.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:rawg/features/dashboard/data/models/remote/game_overview_model.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';
import 'package:rawg/features/dashboard/domain/entities/game_page.dart';
import 'package:rawg/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ConnectionChecker _connectionChecker;

  final DashboardLocalDataSource _localDataSource;

  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource, this._localDataSource, this._connectionChecker);

  Future<ApiResult<GameOverview>> _getCachedGameOverview(int id) async {
    try {
      final cached = await _localDataSource.getCachedGameOverview(id);
      if (cached != null) return ApiSuccess(cached);
    } catch (_) {}
    return ApiFailure('errors.noCache'.tr());
  }

  @override
  Future<ApiResult<GameOverview>> getGameOverview(int id) async {
    try {
      if (await _connectionChecker.isConnected) {
        final result = await _remoteDataSource.getGameOverview(id);
        if (result is ApiSuccess<GameOverviewModel>) {
          await _localDataSource.cacheGameOverview(result.data);
          return result;
        }
      }
    } catch (_) {}
    return _getCachedGameOverview(id);
  }

  @override
  Future<ApiResult<GamePage>> getGames({int page = 1, int pageSize = ApiConstants.pageSize, String? platforms, String? searchQuery}) async {
    try {
      if (!await _connectionChecker.isConnected) return ApiFailure('errors.noInternet'.tr());
      return await _remoteDataSource.getGames(page: page, pageSize: pageSize, platforms: platforms, searchQuery: searchQuery);
    } catch (_) {
      return ApiFailure('errors.default'.tr());
    }
  }
}
