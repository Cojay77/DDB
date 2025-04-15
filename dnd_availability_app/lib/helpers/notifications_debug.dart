import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsDebug extends StatefulWidget {
  const NotificationsDebug({super.key});

  @override
  State<NotificationsDebug> createState() => _NotificationsDebugState();
}

class _NotificationsDebugState extends State<NotificationsDebug> {
  String _status = "🕵️ En attente...";
  String? _token;

  @override
  void initState() {
    super.initState();
    _initNotificationsCheck();
  }

  Future<void> _initNotificationsCheck() async {
    if (!kIsWeb) {
      setState(() {
        _status = "❌ Ce test ne concerne que le Web";
      });
      return;
    }

    try {
      final permission = await FirebaseMessaging.instance.requestPermission();
      debugPrint("🔐 Permission : ${permission.authorizationStatus}");

      if (permission.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await FirebaseMessaging.instance.getToken();
        setState(() {
          _token = token;
          _status =
              token != null
                  ? "✅ Token reçu ! Notifications activées"
                  : "❌ Token null malgré autorisation";
        });
      } else {
        setState(() {
          _status = "❌ Notifications refusées par l'utilisateur";
        });
      }
    } catch (e) {
      setState(() {
        _status = "💥 Erreur : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔔 Test Notifications Web",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(_status),
            if (_token != null) ...[
              const SizedBox(height: 10),
              Text("📦 Token :"),
              SelectableText(_token!, style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
