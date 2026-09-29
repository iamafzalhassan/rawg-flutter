import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rawg/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:rawg/features/dashboard/data/models/local/hive_game_overview_model.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() {
    hiveDirectory = Directory.systemTemp.createTempSync('rawg_hive_test');
    Hive.init(hiveDirectory.path);
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(HiveGameOverviewModelAdapter());
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    if (hiveDirectory.existsSync()) hiveDirectory.deleteSync(recursive: true);
  });

  group('DashboardLocalDataSourceImpl', () {
    test('returns a cached overview with every stored field', () async {
      final DashboardLocalDataSourceImpl local = DashboardLocalDataSourceImpl();

      await local.cacheGameOverview(const GameOverview(id: 3328, metacritic: 92, descriptionRaw: 'Geralt hunts monsters.', website: 'https://thewitcher.com', publishers: ['CD PROJEKT RED']));
      final GameOverview? cached = await local.getCachedGameOverview(3328);

      expect(cached?.id, 3328);
      expect(cached?.metacritic, 92);
      expect(cached?.descriptionRaw, 'Geralt hunts monsters.');
      expect(cached?.website, 'https://thewitcher.com');
      expect(cached?.publishers, ['CD PROJEKT RED']);
    });

    test('reads an overview written by an earlier session from disk', () async {
      await DashboardLocalDataSourceImpl().cacheGameOverview(const GameOverview(id: 3328, metacritic: 92, descriptionRaw: 'Geralt hunts monsters.', website: 'https://thewitcher.com', publishers: ['CD PROJEKT RED']));
      await Hive.close();

      final GameOverview? cached = await DashboardLocalDataSourceImpl().getCachedGameOverview(3328);

      expect(cached?.metacritic, 92);
      expect(cached?.publishers, ['CD PROJEKT RED']);
    });

    test('returns null when nothing is cached', () async {
      expect(await DashboardLocalDataSourceImpl().getCachedGameOverview(3328), isNull);
    });

    test('returns null when the cached overview is 24 hours old', () async {
      final Box<HiveGameOverviewModel> box = await Hive.openBox<HiveGameOverviewModel>('game-overview-cache');
      await box.put('overview-3328', HiveGameOverviewModel(id: 3328, metacritic: 92, descriptionRaw: '', website: '', publisherNames: const [], cachedAt: DateTime.now().subtract(const Duration(hours: 24))));

      expect(await DashboardLocalDataSourceImpl().getCachedGameOverview(3328), isNull);
    });
  });
}
