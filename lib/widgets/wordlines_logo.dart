import 'package:flutter/cupertino.dart';

import '../theme/game_colors.dart';

class WordLinesLogo extends StatelessWidget {
  final double fontSize;

  const WordLinesLogo({
    super.key,
    this.fontSize = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "WordLines",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Baloo2',
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 4,
        color: GameColors.primary,
        shadows: [
          Shadow(
            blurRadius: 12,
            color: GameColors.primary.withOpacity(0.8),
            offset: Offset.zero,
          ),
          Shadow(
            blurRadius: 24,
            color: GameColors.secondary.withOpacity(0.6),
            offset: Offset.zero,
          ),
        ],
      ),
    );
  }
}
