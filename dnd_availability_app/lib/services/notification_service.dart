import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> registerWebToken(String userId) async {
  if (!kIsWeb) return;

  try {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final ref = FirebaseDatabase.instance.ref('webTokens/$userId');
      await ref.set(token);
      debugPrint("✅ Web token enregistré : $token");
    }
  } catch (e) {
    debugPrint("❌ Erreur lors de l'enregistrement du token Web : $e");
  }
}
