import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/game_session.dart';
import '../services/firebase_service.dart';

class GameSessionsScreen extends StatefulWidget {
  const GameSessionsScreen({super.key});

  @override
  State<GameSessionsScreen> createState() => _GameSessionsScreenState();
}

class _GameSessionsScreenState extends State<GameSessionsScreen> {
  final FirebaseGameService _gameService = FirebaseGameService();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  List<GameSession> sessions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final data = await _gameService.fetchSessions();
    setState(() {
      sessions = data;
      loading = false;
    });
  }

  Future<void> toggleAvailability(GameSession session, bool value) async {
    await _gameService.toggleAvailability(session.id, _userId, value);
    await loadSessions(); // recharge les données après changement
  }

  int countAvailable(GameSession session) {
    return session.availability.values.where((v) => v == true).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sessions de jeu")),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  //final isAvailable = session.availability[_userId] ?? false;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: const Icon(Icons.expand_more),
                      title: Text(
                        "📅 ${session.date}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${countAvailable(session)} joueur(s) disponible(s)",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: session.availability[_userId] ?? false,
                        onChanged: (val) => toggleAvailability(session, val),
                      ),
                      children: [
                        FutureBuilder<List<String>>(
                          future: _gameService.getAvailablePlayerNames(session),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              );
                            }

                            final players = snapshot.data ?? [];
                            if (players.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Aucun joueur disponible"),
                              );
                            }

                            return Column(
                              children:
                                  players
                                      .map(
                                        (email) => ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Text(email),
                                        ),
                                      )
                                      .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
