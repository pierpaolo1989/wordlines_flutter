import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worldlines_mobile/home/onboarding_page.dart';
import 'package:worldlines_mobile/splash/splash_page.dart';
import 'package:worldlines_mobile/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gzooygohjjdspwileeyw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6b295Z29oampkc3B3aWxlZXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1ODgxMDUsImV4cCI6MjA4MjE2NDEwNX0.Ks2iSXhpLK682RSFwEbjZnRyL_dO7tY7k-L90VDaFVE',
  );
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
