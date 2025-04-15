import 'package:dnd_availability_app/models/update_banner.dart';
import 'package:dnd_availability_app/utils/platform_utils_stub.dart';
import 'package:dnd_availability_app/utils/pwa_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:js' as js;
import 'package:dnd_availability_app/helpers/notifications_debug.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("homeMessage");
  //String _homeMessage = "Chargement";
  bool isAdmin = false;
  String? userEmail;
  String? displayName;
  String? version;
  String? buildNumber;

  @override
  void initState() {
    super.initState();
    //_fetchHomeMessage();
    final user = _authService.currentUser;
    userEmail = user?.email;
    displayName = user?.displayName;
    if (user != null) {
      _authService.isUserAdmin(user.uid).then((value) {
        setState(() {
          isAdmin = value;
        });
      });
    }
    _loadVersion();
  }

  Future<String> _fetchHomeMessage() async {
    final messageRef = _dbRef;
    final snap = await messageRef.child('text').get();
    if (snap.exists) {
      return snap.value.toString().replaceAll("\\n", "\n");
    } else {
      return "Pas de message";
    }
  }

  Future<String> _fetchReleaseNote() async {
    final messageRef = _dbRef;
    final snap = await messageRef.child('text').get();
    if (snap.exists) {
      return snap.value.toString().replaceAll("\\n", "\n");
    } else {
      return "Pas de message";
    }
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdmin) const NotificationsDebug(),
            Text("Bienvenue, ${displayName ?? 'utilisateur'} !"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/sessions');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Voir les sessions"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isAdmin)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                icon: const Icon(Icons.shield),
                label: const Text("Espace Admin"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.person),
              label: const Text("Mettre à jour le profil"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.messenger,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<String>(
                      future: _fetchHomeMessage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData) {
                          return const Text("Aucun message pour le moment.");
                        }
                        return Text(
                          snapshot.data!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        );
                      },
                    ),
                    Icon(
                      Icons.new_releases,
                      size: 30,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<String>(
                      future: _fetchReleaseNote(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (!snapshot.hasData) {
                          return const Text("");
                        }
                        return Text(
                          snapshot.data!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (kIsWeb && !isIOSBrowser() && !isAppInstalled()) ...[
              ElevatedButton(
                onPressed: () {
                  js.context.callMethod('promptInstall');
                },
                child: const Text("Installer l’application"),
              ),
            ],
            if (kIsWeb && isIOSBrowser()) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.ios_share, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Pour installer l'application :\nAppuyez sur "
                          "le bouton de partage (en bas de l'écran), "
                          "puis \"Ajouter à l’écran d’accueil\".",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const UpdateBanner(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          border: const Border(top: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Image.asset('assets/logo.png', height: 40, fit: BoxFit.contain),
            const Spacer(flex: 1),
            Text("D&D&B - version $version", style: TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
