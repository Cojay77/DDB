import 'package:firebase_database/firebase_database.dart';
import '../models/game_session.dart';

class FirebaseGameService {
  final db = FirebaseDatabase.instance;

  Future<List<GameSession>> fetchSessions() async {
    final ref = db.ref("sessions");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      return data.entries.map<GameSession>((e) {
        return GameSession.fromMap(e.key, Map<String, dynamic>.from(e.value));
      }).toList();
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

  Future<void> toggleAvailability(String sessionId, String userId, bool available) async {
    final ref = db.ref("sessions/$sessionId/availability/$userId");
    await ref.set(available);
  }
}
