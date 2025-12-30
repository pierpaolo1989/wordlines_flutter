import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worldlines_mobile/ads/ads_service.dart';
import 'package:worldlines_mobile/data/wordset_repository.dart';
import 'package:worldlines_mobile/game/game_controller.dart';
import 'package:worldlines_mobile/game/game_feedback.dart';
import 'package:worldlines_mobile/game/game_models.dart';
import 'package:worldlines_mobile/leaderboard/leaderboard_page.dart';
import 'package:worldlines_mobile/service/score_service.dart';
import 'package:worldlines_mobile/widgets/game_keyboard.dart';
import 'package:worldlines_mobile/widgets/glitter_overlay.dart';
import 'package:worldlines_mobile/widgets/otp_boxes.dart';

class GuessWordPage extends StatefulWidget {
  final String language;
  const GuessWordPage({super.key, required this.language});

  @override
  State<GuessWordPage> createState() => _GuessWordPageState();
}

class _GuessWordPageState extends State<GuessWordPage> {
  late GameFeedback feedback;
  GameController? controller;
  bool showGlitter = false;
  bool loading = true;
  String? error;

  final repo = WordSetRepository();

  Future<void> _showEndGameDialog(int score) async {
    final user = Supabase.instance.client.auth.currentUser;
    final username = user?.userMetadata?['full_name'] ??
        user?.email?.split('@').first ??
        'Player';
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Partita finita"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Punteggio: $score"),
            const SizedBox(height: 12),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () async {
              await ScoreService.saveScore(
                username: username,
                language: widget.language,
                score: score,
              );
              Navigator.pop(context);
            },
            child: const Text("SALVA"),
          ),
        ],
      ),
    );
  }

  Future<void> _showZeroDialog(int score) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) => AlertDialog(
        title: const Text("🎉 Partita finita"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Hai totalizzato 0 punti."),
            SizedBox(height: 12),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center, // 👈 QUI
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("RIPROVA"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    feedback = GameFeedback();
    _loadWords();
  }

  Future<void> _onGameEnd() async {
    final previousScore = controller!.score;
    final keepScore = !controller!.gameOverByLives;

    if (controller!.gameOverByLives && previousScore > 0) {
      await _showEndGameDialog(previousScore);
    } else {
      await _showZeroDialog(previousScore);
    }

    setState(() => loading = true);

    final newWords = await repo.fetchRandom(language: widget.language);

    controller = GameController(
      newWords,
      score: keepScore ? previousScore : 0, // ⬅️ QUI
    )
      ..onGameEnd = _onGameEnd
      ..onShowAd = () {
        AdService.showInterstitial();
      };

    setState(() => loading = false);
  }

  Future<void> _loadWords() async {
    try {
      final words = await repo.fetchRandom(language: widget.language);
      controller = GameController(words)
        ..onGameEnd = _onGameEnd
        ..onShowAd = () {
          AdService.showInterstitial();
        };

      setState(() => loading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.disposeController();
    feedback.dispose();
    super.dispose();
  }

  void _onGuess(String letter) {
    final ctrl = controller!;
    final before = ctrl.revealed.join();

    ctrl.guess(letter);
    final after = ctrl.revealed.join();

    feedback.trigger(before != after ? GameEvent.correct : GameEvent.wrong);

    if (!ctrl.revealed.contains("_")) {
      feedback.trigger(GameEvent.win);
      setState(() => showGlitter = true);
      Future.delayed(
        const Duration(milliseconds: 800),
        () => setState(() => showGlitter = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Errore:\n$error",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: controller!,
      child: Consumer<GameController>(
        builder: (context, ctrl, _) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Score: ${ctrl.score}"),
                ),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ctrl.secondsLeft <= 5
                              ? Colors.redAccent
                              : Theme.of(context).colorScheme.primary,
                        ),
                        child: Text("⏱ ${ctrl.secondsLeft}"),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          ctrl.lives,
                          (_) => const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(ctrl.current.first,
                          style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 20),
                      OtpBoxes(letters: ctrl.revealed),
                      const SizedBox(height: 20),
                      Text(ctrl.current.last,
                          style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 60),
                      GameKeyboard(onKeyPressed: _onGuess),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LeaderboardPage(),
                            ),
                          );
                        },
                        child: const Text("🏆 Classifica"),
                      ),
                    ],
                  ),
                ),
                if (showGlitter) const GlitterOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }
}
