import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldlines_mobile/ads/ads_service.dart';
import 'package:worldlines_mobile/leaderboard/leaderboard_store.dart';

import 'game_controller.dart';
import 'game_feedback.dart';
import 'game_models.dart';
import '../widgets/otp_boxes.dart';
import '../widgets/game_keyboard.dart';
import '../widgets/glitter_overlay.dart';
import '../leaderboard/leaderboard_page.dart';

class GuessWordPage extends StatefulWidget {
  final String language;
  const GuessWordPage({super.key, required this.language});

  @override
  State<GuessWordPage> createState() => _GuessWordPageState();
}

class _GuessWordPageState extends State<GuessWordPage> {
  late GameFeedback feedback;
  late GameController controller;
  bool showGlitter = false;

  final List<WordSet> wordSets = [
    WordSet("CANE", "BANANA", "GATTO"),
    WordSet("SOLE", "COMPUTER", "LUNA"),
    WordSet("MARE", "TELEFONO", "VENTO"),
    WordSet("FUOCO", "ELEFANTE", "ACQUA"),
    WordSet("LIBRO", "ASTRONAVE", "STELLA"),
    WordSet("PIANO", "CHITARRA", "MUSICA"),
  ];

  @override
  void initState() {
    super.initState();
    feedback = GameFeedback();

    controller = GameController(wordSets)
      ..onGameEnd = () {
        _showEndGameDialog(controller.score);
      }
      ..onShowAd = () {
        if (!kIsWeb) AdService.showInterstitial();
      };

    if (!kIsWeb) {
      AdService.loadInterstitial();
    }
  }

  @override
  void dispose() {
    controller.disposeController();
    feedback.dispose();
    super.dispose();
  }

  void _onGuess(String letter) {
    final before = controller.revealed.join();
    controller.guess(letter);
    final after = controller.revealed.join();

    if (before != after) {
      feedback.trigger(GameEvent.correct);
    } else {
      feedback.trigger(GameEvent.wrong);
    }

    if (!controller.revealed.contains("_")) {
      feedback.trigger(GameEvent.win);
      setState(() => showGlitter = true);
      Future.delayed(
        const Duration(milliseconds: 800),
        () => setState(() => showGlitter = false),
      );
    }
  }

  Future<void> _showEndGameDialog(int score) async {
    final controllerText = TextEditingController();

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
            TextField(
              controller: controllerText,
              decoration: const InputDecoration(labelText: "Il tuo nome"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await LeaderboardStorage.save(
                ScoreEntry(controllerText.text, score),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("SALVA"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
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
                      Text(
                        "⏱ ${ctrl.secondsLeft}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ctrl.secondsLeft <= 5
                              ? Colors.redAccent
                              : Theme.of(context).colorScheme.primary,
                        ),
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
