import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worldlines_mobile/home/onboarding_page.dart';
import 'package:worldlines_mobile/splash/splash_page.dart';
import 'package:worldlines_mobile/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WordLinesApp());
}

class WordLinesApp extends StatefulWidget {
  const WordLinesApp({super.key});

  @override
  State<WordLinesApp> createState() => _WordLinesAppState();
}

class _WordLinesAppState extends State<WordLinesApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashPage());
  }
}
