import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worldlines_mobile/home/onboarding_page.dart';
import '../home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _loading = true;
  bool _seenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              _seenOnboarding ? const HomePage() : const OnboardingPage(),
        ),
      );
    });
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seenOnboarding') ?? false;
    setState(() {
      _seenOnboarding = seen;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "WORDLINES",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: Colors.cyanAccent,
          ),
        ),
      ),
    );
  }
}
