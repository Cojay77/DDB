// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'app.dart';
/* import 'dart:js' as js;
import 'dart:js_util' as jsu; */
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission();

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
  }
  

/*   Future<void> registerCustomSW() async {
    try {
      final navigator = jsu.getProperty(js.context, 'navigator');
      if (navigator == null) {
        debugPrint("❌ navigator introuvable");
        return;
      }

      final serviceWorker = jsu.getProperty(navigator, 'serviceWorker');
      if (serviceWorker == null) {
        debugPrint("❌ serviceWorker introuvable");
        return;
      }

      final result = await jsu.promiseToFuture(
        jsu.callMethod(serviceWorker, 'register', [
          '/DDB/firebase-messaging-sw.js',
          jsu.jsify({'scope': '/DDB/'}),
        ]),
      );

      debugPrint("✅ SW custom enregistré avec succès : $result");
    } catch (e) {
      debugPrint("💥 Erreur SW : $e");
    }
  } */

  runApp(const DndApp());

   /*  if (kIsWeb) {
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
    }); */
  }
