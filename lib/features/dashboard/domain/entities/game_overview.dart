class GameOverview {
  final int? id;
  final int? metacritic;

  final String? descriptionRaw;
  final String? website;

  final List<String> publishers;

  const GameOverview({this.id, this.metacritic, this.descriptionRaw, this.website, this.publishers = const []});

  String get publisherNames => publishers.join(', ');

  String get shortDescription {
    final text = descriptionRaw ?? '';
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    return (sentences.length <= 5 ? text : sentences.take(5).join(' ')).replaceAll(RegExp(r'[^a-zA-Z0-9\s\.]'), '');
  }
}
