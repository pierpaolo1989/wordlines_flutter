import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worldlines_mobile/login/auth_provider.dart';
import 'package:worldlines_mobile/theme/theme_provider.dart';
import '../game/guess_word_page.dart';
import '../game/game_controller.dart';
import '../game/game_models.dart';
import 'package:country_icons/country_icons.dart';
import '../widgets/wordlines_logo.dart';
import 'login_page.dart';
import '../leaderboard/leaderboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = "IT";

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const WordLinesLogo(fontSize: 48),
              const SizedBox(height: 40),

              // Selettore lingua
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: isDark ? theme.cardColor : Colors.white,
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
                          const Text("Italiano"),
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
                          const Text("English"),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedLanguage = value!);
                  },
                ),
              )
              ,

              const SizedBox(height: 30),

              // Pulsante PLAY
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
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
                child: const Text(
                  "PLAY",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 2, // 👈 più spessa
                      color: theme.colorScheme.primary.withOpacity(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary, // 👈 dot pieno
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: theme.colorScheme.primary.withOpacity(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  backgroundColor: theme.cardColor,
                  foregroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LeaderboardPage()),
                  );
                },
                child: const Text(
                  "🏆 Classifica",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 60),
              Text(
                "v1.0.0",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
