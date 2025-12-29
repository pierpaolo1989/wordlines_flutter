import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldlines_mobile/login/auth_provider.dart';
import 'package:worldlines_mobile/theme/theme_provider.dart';
import '../game/guess_word_page.dart';
import '../game/game_controller.dart';
import '../game/game_models.dart';
import 'package:country_icons/country_icons.dart';
import 'login_page.dart'; // <-- nuova pagina login

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = "IT";
  bool isDarkMode = true; // stato per il tema

  // lista delle parole (esempio)
  final List<WordSet> wordSets = [
    WordSet("CANE", "BANANA", "GATTO"),
    WordSet("SOLE", "COMPUTER", "LUNA"),
    WordSet("MARE", "TELEFONO", "VENTO"),
    WordSet("FUOCO", "ELEFANTE", "ACQUA"),
    WordSet("LIBRO", "ASTRONAVE", "STELLA"),
    WordSet("PIANO", "CHITARRA", "MUSICA"),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    print("HOME BUILD – logged: ${auth.isLoggedIn}");
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!auth.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            )
          else
            PopupMenuButton(
              icon: const Icon(Icons.person),
              itemBuilder: (_) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text("👤 ${auth.username}"),
                ),
                PopupMenuItem(
                  child: const Text("Logout"),
                  onTap: () async {
                    await auth.signOut();
                  },
                ),
              ],
            ),

          // tema
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "WORDLINES",
                  style: TextStyle(
                    fontSize: 42,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 40), // Spazio dal titolo AppBar
                DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: Colors.black,
                  items: [
                    DropdownMenuItem(
                      value: "IT",
                      child: Row(
                        children: [
                          Image.asset(
                            'icons/flags/png/it.png',
                            package: 'country_icons',
                            width: 32,
                          ),
                          const SizedBox(width: 8),
                          const Text("Italiano",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "EN",
                      child: Row(
                        children: [
                          Image.asset(
                            'icons/flags/png/gb.png',
                            package: 'country_icons',
                            width: 32,
                          ),
                          const SizedBox(width: 8),
                          const Text("English",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedLanguage = value!);
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) => GameController(wordSets),
                          child: GuessWordPage(language: selectedLanguage),
                        ),
                      ),
                    );
                  },
                  child: const Text("PLAY", style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              "v1.0.0",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _changeTheme(ThemeMode mode) {
    // Cambia il tema globalmente
    // Serve un approccio come Riverpod o Provider per modificare il tema
    // Per esempio con Provider potresti avere un ThemeNotifier
  }
}
