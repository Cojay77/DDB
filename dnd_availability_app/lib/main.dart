// import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /*   await FirebaseMessaging.instance.requestPermission();

  // ✅ Forcer l’enregistrement du SW avec l’URL absolue correcte
  if (html.window.navigator.serviceWorker != null) {
    try {
      final registration = await html.window.navigator.serviceWorker!.register(
        '/DDB/firebase-messaging-sw.js',
      );
      print("✅ SW personnalisé enregistré : $registration");
    } catch (e) {
      print("💥 Erreur SW : $e");
    }
  } else {
    print("❌ navigator.serviceWorker introuvable");
  } */

  if (kIsWeb) {
    print("✅ Enregistrement du SW délégué au JS dans index.html");
  }

  /* if (kIsWeb) {
    try {
      final registration = await html.window.navigator.serviceWorker!.register(
        '/DDB/firebase-messaging-sw.js',
      );

      print("✅ SW personnalisé enregistré : $registration");

      // 👇 Injecter manuellement le Service Worker dans Firebase Messaging (interop JS)

      final firebase = js_util.getProperty(js_util.globalThis, 'firebase');

      if (firebase != null && js_util.hasProperty(firebase, 'messaging')) {
        final messaging = js_util.callMethod(firebase, 'messaging', []);
        js_util.callMethod(messaging, 'useServiceWorker', [registration]);
        print("📬 Service Worker injecté dans Firebase Messaging.");
      } else {
        print("⚠️ Firebase ou messaging non disponible côté JS.");
      }
    } catch (e) {
      print("💥 Erreur SW interop : $e");
    }
  } */

  runApp(const DndApp());
}
