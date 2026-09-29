import 'package:flutter_test/flutter_test.dart';
import 'package:rawg/features/dashboard/data/models/local/hive_game_overview_model.dart';

void main() {
  HiveGameOverviewModel cachedAgo(Duration age) =>
      HiveGameOverviewModel(id: 3328, metacritic: 92, descriptionRaw: 'Geralt hunts monsters.', website: 'https://thewitcher.com', publisherNames: const ['CD PROJEKT RED'], cachedAt: DateTime.now().subtract(age));

  group('HiveGameOverviewModel.isStale', () {
    test('is fresh just before 24 hours', () {
      expect(cachedAgo(const Duration(hours: 23, minutes: 59)).isStale, isFalse);
    });

    test('is stale at exactly 24 hours', () {
      expect(cachedAgo(const Duration(hours: 24)).isStale, isTrue);
    });

    test('is stale within the hour after 24 hours', () {
      expect(cachedAgo(const Duration(hours: 24, minutes: 30)).isStale, isTrue);
    });
  });

  group('HiveGameOverviewModel.toGameOverview', () {
    test('keeps every cached field', () {
      final overview = cachedAgo(Duration.zero).toGameOverview();

      expect(overview.id, 3328);
      expect(overview.metacritic, 92);
      expect(overview.descriptionRaw, 'Geralt hunts monsters.');
      expect(overview.website, 'https://thewitcher.com');
      expect(overview.publishers, ['CD PROJEKT RED']);
    });
  });
}
