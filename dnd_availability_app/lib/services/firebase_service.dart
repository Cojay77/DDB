import 'package:firebase_database/firebase_database.dart';
import '../models/game_session.dart';

class FirebaseGameService {
  final db = FirebaseDatabase.instance;

  Future<List<GameSession>> fetchSessions() async {
    final ref = db.ref("sessions");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      List<GameSession> sessions =
          data.entries.map<GameSession>((e) {
            return GameSession.fromMap(
              e.key,
              Map<String, dynamic>.from(e.value),
            );
          }).toList();
      sessions.sort((a, b) => a.parsedDate.compareTo(b.parsedDate));
      return sessions;
    } else {
      return [];
    }
  }

  Future<void> createSession(String date, String userId, String title) async {
    final ref = db.ref("sessions").push();
    await ref.set({
      "title": title,
      "date": date,
      "createdBy": userId,
      "availability": {},
    });
  }

  Future<void> toggleAvailability(
    String sessionId,
    String userId,
    bool available,
  ) async {
    final ref = db.ref("sessions/$sessionId/availability/$userId");
    await ref.set(available);
  }

  Future<List<String>> getAvailablePlayerNames(GameSession session) async {
    final db = FirebaseDatabase.instance;
    final userRef = db.ref("users");

    List<String> displayNames = [];

    for (final entry in session.availability.entries) {
      final uid = entry.key;
      final isAvailable = entry.value;

      if (isAvailable == true) {
        final snap = await userRef.child(uid).get();
        if (snap.exists) {
          final data = snap.value as Map;
          displayNames.add(data['displayName'] ?? uid);
        } else {
          displayNames.add(uid); // fallback si l'utilisateur n'est pas en DB
        }
      }
    }

    return displayNames;
  }
}
