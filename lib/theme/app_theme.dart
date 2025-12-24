import 'package:flutter/material.dart';
import 'game_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: GameColors.background,
    primaryColor: GameColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: GameColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: GameColors.primary,
        letterSpacing: 2,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: GameColors.textPrimary),
      bodyMedium: TextStyle(color: GameColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GameColors.card,
        foregroundColor: GameColors.primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
