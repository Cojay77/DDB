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

  runApp(const DndApp());
}
