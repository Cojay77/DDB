import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> checkUpdate(BuildContext context) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final ref = FirebaseDatabase.instance.ref("appConfig");

    final snapshot = await ref.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;

    final minVersion = data?["minVersion"]?.toString();
    final updateMessage =
        data?["messageUpdate"]?.toString() ??
        "Une mise à jour est disponible. Veuillez redémarrer ou réinstaller l'application.";

    if (minVersion != null && minVersion != currentVersion) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("🆕 Mise à jour disponible"),
                content: Text(updateMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      }
    }
  } catch (e) {
    debugPrint("❌ Erreur checkUpdate: $e");
  }
}
