import 'package:flutter/material.dart';
import 'package:worldlines_mobile/game/game_models.dart';

class GameKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final KeyboardLayout layout;

  GameKeyboard({
    super.key,
    required this.onKeyPressed,
    this.layout = KeyboardLayout.alphabetical,
  });

  Widget _buildKey(String letter) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed: () => onKeyPressed(letter),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.cyanAccent,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Center(
            child: Text(
              letter, // ✅ QUI
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (layout == KeyboardLayout.qwerty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: qwertyLayout.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map(_buildKey).toList(),
            ),
          );
        }).toList(),
      );
    }

    // DEFAULT: alfabetico
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: alphabeticalLayout.map(_buildKey).toList(),
    );
  }
}
