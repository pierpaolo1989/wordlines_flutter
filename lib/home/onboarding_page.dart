import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worldlines_mobile/home/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Benvenuto in WordLines!",
      "description": "Indovina la parola centrale usando le lettere fornite."
    },
    {
      "title": "Swipe per cambiare",
      "description": "Puoi scorrere a destra o sinistra per cambiare la parola."
    },
    {
      "title": "Attento al tempo!",
      "description":
          "Hai un tempo limitato per indovinare ogni parola. Non perderti!"
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          page['title']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page['description']!,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == _pages.length - 1 ? "Inizia" : "Avanti",
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
