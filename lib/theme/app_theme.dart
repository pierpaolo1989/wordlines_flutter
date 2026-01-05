import 'package:flutter/material.dart';
import 'game_colors.dart';

class AppTheme {
  // DARK THEME
  static final ThemeData darkTheme = ThemeData(
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
        inherit: true,
      ),
      iconTheme: IconThemeData(color: GameColors.primary),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: GameColors.textPrimary, inherit: true),
      bodyMedium: TextStyle(color: GameColors.textSecondary, inherit: true),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GameColors.card,
        foregroundColor: GameColors.primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          inherit: true,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.cyan,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.cyan,
        letterSpacing: 2,
        inherit: true,
      ),
      iconTheme: IconThemeData(color: Colors.cyan),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, inherit: true),
      bodyMedium: TextStyle(color: Colors.grey, inherit: true),
    ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan, // pieno
          foregroundColor: Colors.white, // contrasto massimo
          elevation: 2,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
  );
}
