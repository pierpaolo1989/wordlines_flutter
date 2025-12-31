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
import 'package:worldlines_mobile/utils/game_score_formatter.dart';
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
    final isGuest = user == null;

    final TextEditingController nameController = TextEditingController();

    final defaultUsername =
        user?.userMetadata?['full_name'] ?? user?.email?.split('@').first;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "🎉 Partita finita",
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Punteggio: $score",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 👇 MOSTRA SOLO SE NON LOGGATO
              if (isGuest)
                TextField(
                  controller: nameController,
                  textAlign: TextAlign.center,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    counterText: "",
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () async {
                final username =
                    isGuest ? nameController.text.trim() : defaultUsername!;

                if (username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Inserisci un nome valido"),
                    ),
                  );
                  return;
                }

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
        );
      },
    );
  }

  Future<void> _showZeroDialog(int score) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (_) => AlertDialog(
        title: const Text("🎉 Partita finita", textAlign: TextAlign.center),
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
    }
    if (previousScore == 0) {
      await _showZeroDialog(previousScore);
    }

    setState(() => loading = true);

    final newWords = await repo.fetchRandom(language: widget.language);

    controller = GameController(
      newWords,
      score: keepScore ? previousScore : 0,
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
                  child: Text(
                    ScoreFormatter.format(ctrl.score),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron', // se usi font game
                    ),
                  ),
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
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _hintButton(
                            icon: Icons.skip_next,
                            badge: ctrl.skipHintsLeft,
                            enabled: ctrl.skipHintsLeft > 0,
                            onTap: ctrl.skipWord,
                          ),
                          const SizedBox(width: 24),
                          _hintButton(
                            icon: Icons.pause_circle,
                            badge: ctrl.freezeHintsLeft,
                            enabled:
                                ctrl.freezeHintsLeft > 0 && !ctrl.timeFrozen,
                            onTap: ctrl.freezeTime,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      GameKeyboard(
                          layout: KeyboardLayout.qwerty,
                          onKeyPressed: _onGuess),
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

Widget _hintButton({
  required IconData icon,
  required int badge,
  required VoidCallback onTap,
  required bool enabled,
}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      IconButton(
        iconSize: 28,
        onPressed: enabled ? onTap : null,
        icon: Icon(icon),
      ),
      Positioned(
        right: -2,
        top: -2,
        child: CircleAvatar(
          radius: 9,
          backgroundColor: Colors.redAccent,
          child: Text(
            badge.toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}
