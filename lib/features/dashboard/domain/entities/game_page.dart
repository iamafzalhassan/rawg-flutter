import 'package:rawg/features/dashboard/domain/entities/game.dart';

class GamePage {
  final bool hasMore;

  final int page;

  final List<Game> games;

  const GamePage({required this.hasMore, required this.page, required this.games});
}
