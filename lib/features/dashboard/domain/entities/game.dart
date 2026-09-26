import 'package:easy_localization/easy_localization.dart';

class Game {
  final int playtime;
  final int ratingsCount;
  final int? id;

  final String name;

  final List<String> genres;
  final List<String> platforms;

  final DateTime released;

  const Game({required this.playtime, required this.ratingsCount, this.id, required this.name, required this.genres, required this.platforms, required this.released});

  String get genreNames => genres.isEmpty ? 'genres.action'.tr() : genres.join(', ');
  String get platformNames => platforms.join(', ');
  String get releaseDate => DateFormat('MMM d, yyyy').format(released);
}
