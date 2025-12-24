import 'package:flutter/material.dart';

class OtpBoxes extends StatelessWidget {
  final List<String> letters;

  const OtpBoxes({
    super.key,
    required this.letters,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // spazio totale disponibile
        final totalWidth = constraints.maxWidth;

        // margine orizzontale tra le box
        const spacing = 3.0;

        // larghezza box calcolata dinamicamente
        final boxWidth =
            (totalWidth - (letters.length - 1) * spacing) / letters.length;

        // limiti min/max per non diventare troppo piccole o grandi
        final width = boxWidth.clamp(30.0, 54.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(letters.length, (index) {
            return Container(
              width: width,
              height: width * 1.2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: letters[index] != "_"
                      ? Colors.cyanAccent
                      : Colors.blueGrey,
                  width: 2,
                ),
                boxShadow: letters[index] != "_"
                    ? const [
                        BoxShadow(
                          color: Colors.cyanAccent,
                          blurRadius: 8,
                        )
                      ]
                    : [],
              ),
              child: Text(
                letters[index],
                style: TextStyle(
                  fontSize: width * 0.5,
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
