class WordSet {
  final String first;
  final String middle;
  final String last;

  WordSet(this.first, this.middle, this.last);
}

class ScoreEntry {
  final String name;
  final int score;

  ScoreEntry(this.name, this.score);

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) =>
      ScoreEntry(json['name'], json['score']);
}
