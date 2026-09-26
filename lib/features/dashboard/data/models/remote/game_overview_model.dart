import 'package:rawg/features/dashboard/domain/entities/game_overview.dart';

class GameOverviewModel extends GameOverview {
  const GameOverviewModel({super.id, super.metacritic, super.descriptionRaw, super.website, super.publishers});

  factory GameOverviewModel.fromJson(Map<String, dynamic> json) =>
      GameOverviewModel(id: json['id'], metacritic: json['metacritic'], descriptionRaw: json['description_raw'], website: json['website'], publishers: [for (final publisher in json['publishers'] ?? const []) publisher['name'] ?? '']);
}
