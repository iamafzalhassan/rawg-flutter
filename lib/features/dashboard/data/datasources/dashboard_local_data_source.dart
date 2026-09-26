import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawg/features/dashboard/data/models/local/hive_game_overview_model.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';

abstract interface class DashboardLocalDataSource {
  Future<void> cacheGameOverview(GameOverview overview);

  Future<GameOverview?> getCachedGameOverview(int id);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _boxName = 'game-overview-cache';

  Box<HiveGameOverviewModel>? _hiveGameOverviewBox;

  Future<Box<HiveGameOverviewModel>> get _box async => _hiveGameOverviewBox ??= await Hive.openBox<HiveGameOverviewModel>(_boxName);

  @override
  Future<void> cacheGameOverview(GameOverview overview) async => (await _box).put('overview-${overview.id}', HiveGameOverviewModel.fromGameOverview(overview));

  @override
  Future<GameOverview?> getCachedGameOverview(int id) async {
    final cached = (await _box).get('overview-$id');
    return cached == null || cached.isStale ? null : cached.toGameOverview();
  }
}
