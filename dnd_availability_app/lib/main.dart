import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'dart:js' as js;
import 'dart:js_util' as jsu;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission();

  Future<void> registerCustomSW() async {
  try {
    final navigator = jsu.getProperty(js.context, 'navigator');
    final serviceWorker = jsu.getProperty(navigator, 'serviceWorker');

    final result = await jsu.promiseToFuture(
      jsu.callMethod(serviceWorker, 'register', [
        '/DDB/firebase-messaging-sw.js',
        jsu.jsify({'scope': '/DDB/'})
      ])
    );

    debugPrint("✅ SW custom enregistré avec succès : $result");
  } catch (e) {
    debugPrint("💥 Erreur SW : $e");
  }
}


  if (kIsWeb) {
    await registerCustomSW();

    FirebaseMessaging.instance
        .getToken(
          vapidKey:
              "BPnJahKmOlUPaI_adobh5Zp53Z25q02sHebm4MP5JhCnkY_eO8-1C5sQVRZuF9rTs6S7j4vgD9ydloKy4IFz_3M",
        )
        .then((token) {
          debugPrint("✅ Token Web : $token");
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📥 Message en foreground : ${message.notification?.title}");
    });
  }

  runApp(const DndApp());
}
