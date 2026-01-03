import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:worldlines_mobile/ads/ads_service.dart';
import 'game_models.dart';

class GameController extends ChangeNotifier {
  final List<WordSet> wordSets;

  int currentIndex = 0;
  int currentRound = 1;
  final int maxRounds = 10;
  bool gameOverByLives = false;
  int skipHintsLeft = 2;
  int freezeHintsLeft = 2;
  bool timeFrozen = false;
  final GameDifficulty difficulty;
  int wrongGuesses = 0;

  // -----------------------------
  // SKIP WORD (usa 1 aiuto)
  // -----------------------------
  void skipWord() {
    if (skipHintsLeft <= 0) return;

    skipHintsLeft--;
    next();
    notifyListeners();
  }

  // -----------------------------
  // FREEZE TIME (usa 1 aiuto)
  // -----------------------------
  void freezeTime() {
    if (freezeHintsLeft <= 0 || timeFrozen) return;

    freezeHintsLeft--;
    timeFrozen = true;
    timer?.cancel();

    notifyListeners();
  }

  int lives = 3;
  int score;
  int secondsLeft = 30;

  late String hiddenWord;
  late List<String> revealed;

  Timer? timer;

  VoidCallback? onGameEnd;
  VoidCallback? onShowAd;

  GameController(
    this.wordSets, {
    this.score = 0,
    this.difficulty = GameDifficulty.easy,
  }) {
    startRound();
  }

  WordSet get current => wordSets[currentIndex];

  // -----------------------------
  // ROUND
  // -----------------------------
  void startRound() {
    timer?.cancel();
    timeFrozen = false;
    wrongGuesses = 0;

    hiddenWord = current.middle;
    revealed = List.filled(hiddenWord.length, "_");

    revealed[0] = hiddenWord[0];
    revealed[hiddenWord.length - 1] = hiddenWord[hiddenWord.length - 1];

    secondsLeft = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeFrozen) return;

      secondsLeft--;

      if (secondsLeft <= 0) {
        _onTimeExpired();
      }

      notifyListeners();
    });

    notifyListeners();
  }

  // -----------------------------
  // TIMEOUT → LIFE LOST
  // -----------------------------
  void _onTimeExpired() {
    timer?.cancel();
    lives--;

    if (lives <= 0) {
      gameOverByLives = true;
      endGame();
    } else {
      next();
    }
  }

  // -----------------------------
  // GUESS
  // -----------------------------
  void guess(String letter) {
    letter = letter.toUpperCase();
    bool correct = false;

    for (int i = 0; i < hiddenWord.length; i++) {
      if (hiddenWord[i].toUpperCase() == letter && revealed[i] == "_") {
        revealed[i] = hiddenWord[i];
        score += 10;
        correct = true;
      }
    }

    if (!correct) {
      wrongGuesses++;
      _handleWrongGuess();
    }

    if (!revealed.contains("_")) {
      score += 20;
      wrongGuesses = 0;

      if (currentRound >= maxRounds) {
        gameOverByLives = false;
        endGame();
      } else {
        next();
      }
    }

    notifyListeners();
  }

  void _handleWrongGuess() {
    final maxErrors = switch (difficulty) {
      GameDifficulty.easy => 3,
      GameDifficulty.medium => 2,
      GameDifficulty.hard => 1,
    };

    if (wrongGuesses >= maxErrors) {
      wrongGuesses = 0;
      lives--;

      if (lives <= 0) {
        gameOverByLives = true;
        endGame();
      }
    }
  }

  // -----------------------------
  // NEXT WORD / ROUND
  // -----------------------------
  void next() {
    timer?.cancel();

    if (currentRound >= maxRounds) {
      onShowAd?.call();
      gameOverByLives = false;
      endGame();
      return;
    }

    currentRound++;
    currentIndex = (currentIndex + 1) % wordSets.length;
    startRound();
  }

  void resetIndexAndContinue() {
    currentIndex = 0;
    startRound();
  }

  // -----------------------------
  // GAME END
  // -----------------------------
  void endGame() {
    timer?.cancel();
    onGameEnd?.call();
  }

  void disposeController() {
    timer?.cancel();
  }
}
