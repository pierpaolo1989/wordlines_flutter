import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worldlines_mobile/login/auth_provider.dart';
import 'package:worldlines_mobile/login/reset_password.dart';
import 'package:worldlines_mobile/splash/splash_page.dart';
import 'package:worldlines_mobile/theme/app_theme.dart';
import 'package:worldlines_mobile/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gzooygohjjdspwileeyw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6b295Z29oampkc3B3aWxlZXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1ODgxMDUsImV4cCI6MjA4MjE2NDEwNX0.Ks2iSXhpLK682RSFwEbjZnRyL_dO7tY7k-L90VDaFVE',
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ], child: const WordLinesApp()));
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

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // Naviga alla pagina di reset password
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ResetPasswordPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const SplashPage(),
    );
  }
}
