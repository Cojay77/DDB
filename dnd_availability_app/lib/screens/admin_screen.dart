import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/game_session.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirebaseGameService _gameService = FirebaseGameService();
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  List<GameSession> sessions = [];
  bool loading = true;
  DateTime? selectedDate;

  final TextEditingController dateController = TextEditingController();

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

  Future<void> createSession() async {
    final date = dateController.text.trim();
    if (date.isEmpty) return;

    await _gameService.createSession(date, _userId);
    dateController.clear();
    await loadSessions();
  }

  Future<void> deleteSession(String sessionId) async {
    await _gameService.db.ref("sessions/$sessionId").remove();
    await loadSessions();
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat("EEEE d MMMM", "fr_FR");
    final raw = formatter.format(date);
    return raw[0].toUpperCase() +
        raw.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  locale: const Locale('fr', 'FR'),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                selectedDate != null
                    ? "📅 ${formatDate(selectedDate!)}"
                    : "Choisir une date",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  selectedDate == null
                      ? null
                      : () async {
                        final formatted = formatDate(selectedDate!);
                        await _gameService.createSession(formatted, _userId);
                        setState(() {
                          selectedDate = null;
                        });
                        await loadSessions();
                      },
              child: const Text("Créer une session"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return ListTile(
                            title: Text("📅 ${session.date}"),
                            subtitle: Text("ID : ${session.id}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteSession(session.id),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
