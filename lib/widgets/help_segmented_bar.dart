import 'package:flutter/material.dart';

class HelpSegmentedBar extends StatelessWidget {
  final int skipLeft;
  final int freezeLeft;
  final bool freezeActive;
  final VoidCallback onSkip;
  final VoidCallback onFreeze;

  const HelpSegmentedBar({
    super.key,
    required this.skipLeft,
    required this.freezeLeft,
    required this.freezeActive,
    required this.onSkip,
    required this.onFreeze,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: "skip",
              enabled: skipLeft > 0,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.skip_next, size: 18, color: theme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    "Skip ($skipLeft)",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ],
              ),
            ),
            ButtonSegment(
              value: "freeze",
              enabled: freezeLeft > 0 && !freezeActive,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause_circle, size: 18, color: theme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    "Freeze ($freezeLeft)",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ],
              ),
            ),
          ],
          selected: const {},
          onSelectionChanged: (value) {
            if (value.first == "skip") onSkip();
            if (value.first == "freeze") onFreeze();
          },
          emptySelectionAllowed: true, // fondamentale per evitare il crash
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(MaterialState.disabled)) {
                  return theme.disabledColor.withOpacity(0.2);
                }
                return theme.cardColor; // usa colore pulsante dal tema
              },
            ),
            foregroundColor: MaterialStateProperty.all(theme.primaryColor),
          ),
        ),
      ],
    );
  }
}
