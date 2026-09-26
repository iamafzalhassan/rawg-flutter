import 'package:rawg/features/dashboard/domain/entities/game.dart';

class GameModel extends Game {
  const GameModel({required super.playtime, required super.ratingsCount, super.id, required super.name, required super.genres, required super.platforms, required super.released});

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    playtime: json['playtime'] ?? 0,
    ratingsCount: json['ratings_count'] ?? 0,
    id: json['id'],
    name: json['name'] ?? '',
    genres: [for (final genre in json['genres'] ?? const []) genre['name'] ?? ''],
    platforms: [for (final parent in json['parent_platforms'] ?? const []) parent['platform']['name'] ?? ''],
    released: json['released'] == null ? DateTime.now() : DateTime.parse(json['released']),
  );
}
