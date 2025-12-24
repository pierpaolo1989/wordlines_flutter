import 'package:flutter/material.dart';
import 'package:worldlines_mobile/game/game_models.dart';
import 'package:worldlines_mobile/leaderboard/leaderboard_store.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _medal(int index) {
    if (index > 2) return const SizedBox();

    const medals = ["🥇", "🥈", "🥉"];

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2 * index,
          0.6 + 0.2 * index,
          curve: Curves.elasticOut,
        ),
      ),
      child: Text(
        medals[index],
        style: const TextStyle(fontSize: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Classifica"),
      ),
      body: FutureBuilder<List<ScoreEntry>>(
        future: LeaderboardStorage.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<ScoreEntry> entries = List<ScoreEntry>.from(snapshot.data!)
            ..sort((a, b) => b.score.compareTo(a.score));

          if (entries.isEmpty) {
            return const Center(
              child: Text("Nessun punteggio salvato"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final animation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      index * 0.05,
                      0.8,
                      curve: Curves.easeOutBack,
                    ),
                  );

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // POSIZIONE
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${index + 1}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // MEDAGLIA
                      Expanded(
                        flex: 1,
                        child: Center(child: _medal(index)),
                      ),

                      // NOME
                      Expanded(
                        flex: 4,
                        child: Text(
                          entry.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      // SCORE
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.score.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
