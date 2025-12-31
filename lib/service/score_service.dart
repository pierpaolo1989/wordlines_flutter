import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worldlines_mobile/game/game_models.dart';

class ScoreService {
  static final _client = Supabase.instance.client;

  /// LOAD LEADERBOARD
  static Future<List<ScoreEntry>> fetchScores({String? language}) async {
    final client = Supabase.instance.client;

    final response = language == null
        ? await client
            .from('score')
            .select()
            .order('score', ascending: false)
            .limit(50)
        : await client
            .from('score')
            .select()
            .eq('language', language)
            .order('score', ascending: false)
            .limit(50);

    return (response as List).map((e) => ScoreEntry.fromMap(e)).toList();
  }

  /// SAVE SCORE
  static Future<void> saveScore({
    required String username,
    required String language,
    required int score,
  }) async {
    final user = _client.auth.currentUser;

    await _client.from('score').insert({
      if (user != null) 'user_id': user.id,
      'username': username,
      'language': language,
      'score': score,
    });
  }
}
