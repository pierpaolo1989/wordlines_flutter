import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:worldlines_mobile/ads/ads_service.dart';
import 'game_models.dart';

class GameController extends ChangeNotifier {
  final List<WordSet> wordSets;

  int currentIndex = 0;
  int currentRound = 1;
  final int maxRounds = 10;

  int lives = 3;
  int score = 0;
  int secondsLeft = 30;

  late String hiddenWord;
  late List<String> revealed;

  Timer? timer;

  VoidCallback? onGameEnd;
  VoidCallback? onShowAd;

  GameController(this.wordSets) {
    startRound();
  }

  WordSet get current => wordSets[currentIndex];

  // -----------------------------
  // ROUND
  // -----------------------------
  void startRound() {
    timer?.cancel();

    hiddenWord = current.middle;
    revealed = List.filled(hiddenWord.length, "_");

    revealed[0] = hiddenWord[0];
    revealed[hiddenWord.length - 1] = hiddenWord[hiddenWord.length - 1];

    secondsLeft = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
      endGame();
    } else {
      resetIndexAndContinue();
    }
  }

  // -----------------------------
  // GUESS
  // -----------------------------
  void guess(String letter) {
    letter = letter.toUpperCase();
    bool found = false;

    for (int i = 0; i < hiddenWord.length; i++) {
      if (hiddenWord[i].toUpperCase() == letter && revealed[i] == "_") {
        revealed[i] = hiddenWord[i]; // mantiene il case originale
        score += 10;
        found = true;
      }
    }

    if (!revealed.contains("_")) {
      score += 20;
      next();
    }

    notifyListeners();
  }

  // -----------------------------
  // NEXT WORD / ROUND
  // -----------------------------
  void next() {
    timer?.cancel();

    if (currentRound >= maxRounds) {
      onShowAd = () {
        AdService.showInterstitial();
      };
      currentRound = 0;
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
