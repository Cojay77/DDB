//vide
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateBanner extends StatefulWidget {
  const UpdateBanner({super.key});

  @override
  State<UpdateBanner> createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {
  String? updateMessage;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alreadyDismissed =
          prefs.getBool('update_banner_dismissed') ?? false;
      if (alreadyDismissed) return;

      final info = await PackageInfo.fromPlatform();
      final localVersion = info.version;

      final ref = FirebaseDatabase.instance.ref("appConfig");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final minVersion = data['minVersion']?.toString();
        final message = data['messageUpdate']?.toString();

        if (minVersion != null &&
            message != null &&
            minVersion != localVersion) {
          setState(() {
            updateMessage = message;
            _showBanner = true;
          });
        }
      }
    } catch (e) {
      debugPrint("Erreur dans UpdateBanner : $e");
    }
  }

  void _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('update_banner_dismissed', true);
    setState(() {
      _showBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner || updateMessage == null) return const SizedBox.shrink();

    return Material(
      elevation: 6,
      color: Colors.deepOrange.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                updateMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _dismiss,
            ),
          ],
        ),
      ),
    );
  }
}
