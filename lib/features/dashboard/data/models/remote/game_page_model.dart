import 'package:rawg/features/dashboard/data/models/remote/game_model.dart';
import 'package:rawg/features/dashboard/domain/entities/game_page.dart';

class GamePageModel extends GamePage {
  const GamePageModel({required super.hasMore, required super.page, required super.games});

  factory GamePageModel.fromJson(Map<String, dynamic> json, int page) => GamePageModel(hasMore: json['next'] != null, page: page, games: [for (final game in json['results']) GameModel.fromJson(game)]);
}
