import 'package:flutter/material.dart';
import 'package:worldlines_mobile/game/game_models.dart';

class GameKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final KeyboardLayout layout;

  const GameKeyboard({
    super.key,
    required this.onKeyPressed,
    this.layout = KeyboardLayout.alphabetical,
  });

  static const double keyPadding = 3;
  static const double keyHeight = 42;

  Widget _buildKey(double keyWidth, String letter) {
    return Padding(
      padding: const EdgeInsets.all(keyPadding),
      child: SizedBox(
        width: keyWidth,
        height: keyHeight,
        child: ElevatedButton(
          onPressed: () => onKeyPressed(letter),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade900,
            foregroundColor: Colors.cyanAccent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            letter,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        if (layout == KeyboardLayout.qwerty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: qwertyLayout.map((row) {
              final keysInRow = row.length;
              final totalPadding = keysInRow * keyPadding * 2;
              final keyWidth =
                  (availableWidth - totalPadding) / keysInRow;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row
                    .map((letter) => _buildKey(keyWidth, letter))
                    .toList(),
              );
            }).toList(),
          );
        }

        // Alfabetica (può andare a capo)
        final totalPadding = 10 * keyPadding * 2;
        final keyWidth = (availableWidth - totalPadding) / 10;

        return Wrap(
          alignment: WrapAlignment.center,
          children: alphabeticalLayout
              .map((letter) => _buildKey(keyWidth, letter))
              .toList(),
        );
      },
    );
  }
}
