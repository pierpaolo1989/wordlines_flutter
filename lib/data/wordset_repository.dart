import 'package:supabase_flutter/supabase_flutter.dart';
import '../game/game_models.dart';

class WordSetRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<WordSet>> fetchRandom({
    required String language,
  }) async {
    final rpcName =
        language == 'EN' ? 'get_random_lines_eng' : 'get_random_lines';

    final response = await _client.rpc(rpcName);

    if (response == null) {
      throw Exception("Nessun dato ricevuto da Supabase");
    }

    final List list = response as List;

    return list.map((e) => WordSet.fromJson(e)).toList();
  }
}
