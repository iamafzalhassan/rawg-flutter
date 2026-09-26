import 'package:flutter_test/flutter_test.dart';
import 'package:rawg/core/network/api_result.dart';
import 'package:rawg/core/network/connection_checker.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:rawg/features/dashboard/data/models/remote/game_overview_model.dart';
import 'package:rawg/features/dashboard/data/models/remote/game_page_model.dart';
import 'package:rawg/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';

class FakeConnectionChecker implements ConnectionChecker {
  final bool connected;

  FakeConnectionChecker({required this.connected});

  @override
  Future<bool> get isConnected async => connected;

  @override
  Stream<bool> get onStatusChange => const Stream<bool>.empty();
}

class FakeLocalDataSource implements DashboardLocalDataSource {
  final Map<int, GameOverview> cache = <int, GameOverview>{};

  @override
  Future<void> cacheGameOverview(GameOverview overview) async => cache[overview.id!] = overview;

  @override
  Future<GameOverview?> getCachedGameOverview(int id) async => cache[id];
}

class FakeRemoteDataSource implements DashboardRemoteDataSource {
  final GameOverviewModel overview;

  int overviewCalls = 0;

  FakeRemoteDataSource(this.overview);

  @override
  Future<ApiResult<GameOverviewModel>> getGameOverview(int id) async {
    overviewCalls++;
    return ApiSuccess<GameOverviewModel>(overview);
  }

  @override
  Future<ApiResult<GamePageModel>> getGames({int page = 1, int pageSize = 20, String? platforms, String? searchQuery}) => throw UnimplementedError();
}

void main() {
  GameOverviewModel witcher() => GameOverviewModel(id: 3328, metacritic: 92, descriptionRaw: 'Geralt hunts monsters.', website: 'https://thewitcher.com', publishers: const []);

  group('DashboardRepositoryImpl.getGameOverview', () {
    test('returns the network result and caches it when online', () async {
      final FakeLocalDataSource local = FakeLocalDataSource();
      final FakeRemoteDataSource remote = FakeRemoteDataSource(witcher());
      final DashboardRepositoryImpl repository = DashboardRepositoryImpl(remote, local, FakeConnectionChecker(connected: true));

      final ApiResult<GameOverview> result = await repository.getGameOverview(3328);

      expect(result, isA<ApiSuccess<GameOverview>>());
      expect((result as ApiSuccess<GameOverview>).data.metacritic, 92);
      expect(remote.overviewCalls, 1);
      expect(local.cache[3328]?.website, 'https://thewitcher.com');
    });

    test('serves the cached overview without calling the network when offline', () async {
      final FakeLocalDataSource local = FakeLocalDataSource()..cache[3328] = witcher();
      final FakeRemoteDataSource remote = FakeRemoteDataSource(witcher());
      final DashboardRepositoryImpl repository = DashboardRepositoryImpl(remote, local, FakeConnectionChecker(connected: false));

      final ApiResult<GameOverview> result = await repository.getGameOverview(3328);

      expect(result, isA<ApiSuccess<GameOverview>>());
      expect((result as ApiSuccess<GameOverview>).data.id, 3328);
      expect(remote.overviewCalls, 0);
    });
  });
}
