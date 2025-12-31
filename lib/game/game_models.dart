class WordSet {
  final String first;
  final String middle;
  final String last;

  WordSet(this.first, this.middle, this.last);

  factory WordSet.fromJson(Map<String, dynamic> json) {
    return WordSet(
      json['p1'] as String,
      json['p2'] as String,
      json['p3'] as String,
    );
  }
}

class ScoreEntry {
  final String username;
  final String language;
  final int score;

  ScoreEntry({
    required this.username,
    required this.language,
    required this.score,
  });

  factory ScoreEntry.fromMap(Map<String, dynamic> map) {
    return ScoreEntry(
      username: map['username'],
      language: map['language'],
      score: map['score'],
    );
  }
}

enum KeyboardLayout {
  alphabetical,
  qwerty,
}

const List<String> alphabeticalLayout = [
  'A','B','C','D','E','F','G','H','I','J',
  'K','L','M','N','O','P','Q','R','S','T',
  'U','V','W','X','Y','Z'
];

const List<List<String>> qwertyLayout = [
  ['Q','W','E','R','T','Y','U','I','O','P'],
  ['A','S','D','F','G','H','J','K','L'],
  ['Z','X','C','V','B','N','M'],
];
