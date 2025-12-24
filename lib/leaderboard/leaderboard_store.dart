import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../game/game_models.dart';

class LeaderboardStorage {
  static Future<void> save(ScoreEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('leaderboard');

    List<ScoreEntry> scores = [];

    if (data != null) {
      scores = (jsonDecode(data) as List)
          .map((e) => ScoreEntry.fromJson(e))
          .toList();
    }

    scores.add(entry);
    scores.sort((a, b) => b.score.compareTo(a.score));
    scores = scores.take(10).toList();

    prefs.setString(
      'leaderboard',
      jsonEncode(scores.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<ScoreEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('leaderboard');

    if (data == null) return [];

    return (jsonDecode(data) as List)
        .map((e) => ScoreEntry.fromJson(e))
        .toList();
  }
}
