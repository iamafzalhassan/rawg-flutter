import 'package:dio/dio.dart';
import 'package:rawg/core/constants/api_constants.dart';
import 'package:rawg/core/errors/error_handler.dart';
import 'package:rawg/core/network/api_request.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/features/dashboard/data/models/remote/game_overview_model.dart';
import 'package:rawg/features/dashboard/data/models/remote/game_page_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<ApiResult<GamePageModel>> getGames({int page = 1, int pageSize = ApiConstants.pageSize, String? platforms, String? searchQuery});

  Future<ApiResult<GameOverviewModel>> getGameOverview(int id);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiRequest _apiRequest;

  DashboardRemoteDataSourceImpl(this._apiRequest);

  Future<ApiResult<T>> _request<T>(Future<T> Function() call) async {
    try {
      return ApiSuccess(await call());
    } on DioException catch (e) {
      return ApiFailure(ErrorHandler.messageFor(e));
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  @override
  Future<ApiResult<GameOverviewModel>> getGameOverview(int id) => _request(() async => GameOverviewModel.fromJson((await _apiRequest.get('${ApiConstants.games}/$id')).data));

  @override
  Future<ApiResult<GamePageModel>> getGames({int page = 1, int pageSize = ApiConstants.pageSize, String? platforms, String? searchQuery}) => _request(() async {
    final response = await _apiRequest.get(ApiConstants.games, queryParameters: {'page': page, 'page_size': pageSize, if (platforms?.isNotEmpty ?? false) 'platforms': platforms, if (searchQuery?.isNotEmpty ?? false) 'search': searchQuery});
    return GamePageModel.fromJson(response.data, page);
  });
}
