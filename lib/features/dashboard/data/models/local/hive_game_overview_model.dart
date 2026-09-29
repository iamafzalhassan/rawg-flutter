import 'package:hive_flutter/adapters.dart';
import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';

class HiveGameOverviewModel {
  final int id;
  final int metacritic;

  final String descriptionRaw;
  final String website;

  final List<String> publisherNames;

  final DateTime cachedAt;

  const HiveGameOverviewModel({required this.id, required this.metacritic, required this.descriptionRaw, required this.website, required this.publisherNames, required this.cachedAt});

  factory HiveGameOverviewModel.fromGameOverview(GameOverview overview) =>
      HiveGameOverviewModel(id: overview.id ?? 0, metacritic: overview.metacritic ?? 0, descriptionRaw: overview.descriptionRaw ?? '', website: overview.website ?? '', publisherNames: overview.publishers, cachedAt: DateTime.now());

  bool get isStale => DateTime.now().difference(cachedAt) >= const Duration(hours: 24);

  GameOverview toGameOverview() => GameOverview(id: id, metacritic: metacritic, descriptionRaw: descriptionRaw, website: website, publishers: publisherNames);
}

class HiveGameOverviewModelAdapter extends TypeAdapter<HiveGameOverviewModel> {
  @override
  final int typeId = 1;

  @override
  HiveGameOverviewModel read(BinaryReader reader) {
    final fields = <int, dynamic>{for (var count = reader.readByte(); count > 0; count--) reader.readByte(): reader.read()};
    return HiveGameOverviewModel(id: fields[0], metacritic: fields[1], descriptionRaw: fields[5], website: fields[2], publisherNames: (fields[4] as List).cast<String>(), cachedAt: fields[6]);
  }

  @override
  void write(BinaryWriter writer, HiveGameOverviewModel obj) {
    final fields = <int, Object>{0: obj.id, 1: obj.metacritic, 2: obj.website, 4: obj.publisherNames, 5: obj.descriptionRaw, 6: obj.cachedAt};
    writer.writeByte(fields.length);
    for (final MapEntry(:key, :value) in fields.entries) {
      writer
        ..writeByte(key)
        ..write(value);
    }
  }
}
