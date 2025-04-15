import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission();

  //final token = await FirebaseMessaging.instance.getToken();
  //print("🔑 FCM Token: $token");
  if (!kIsWeb) {
    await FirebaseMessaging.instance.subscribeToTopic("weekly-reminder");
  }

  if (kIsWeb) {
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
