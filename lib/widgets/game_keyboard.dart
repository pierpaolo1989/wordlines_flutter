import 'package:flutter/material.dart';

class GameKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  GameKeyboard({
    super.key,
    required this.onKeyPressed,
  });

  final List<String> alphabet =
      List.generate(26, (i) => String.fromCharCode(65 + i));

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: alphabet.map((letter) {
        return SizedBox(
          width: 40,
          height: 40,
          child: ElevatedButton(
            onPressed: () => onKeyPressed(letter),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey.shade900,
              foregroundColor: Colors.cyanAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}
